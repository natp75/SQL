/*
 6) скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
 */

-- Показ товаров с подстановкой данных из других таблиц
-- Посчитала что часто будет искать конкретный бренд и тип товара в магазине пользователь


-- Скоррелированный подзапрос 


SELECT
    name,
    (SELECT name from brands b2 WHERE products.brand_id = b2.id) as `brand`,
    (SELECT name FROM product_type pt WHERE products.product_type_id = pt.id) as `Тип товара`,
    (SELECT name FROM categories c2 WHERE products.category_id = c2.id) as `Категория`,
    price
from products
-- ;


-- Если пользователь выбрал фильтры какие-то то такой вложенный запрос будет
-- нужно добавить фильтрацию по бренду и типу товара
WHERE products.brand_id = (SELECT id from brands b3 WHERE name = 'Tommy Hilfiger') and
        products.product_type_id = (SELECT id from product_type pt2 WHERE name = 'Рубашки')
ORDER BY price;



-- 2) Представление для админа количество заказов определенного пользователя
-- чтобы отправить на email какую-то скидку
CREATE OR REPLACE VIEW orders_buyer_count AS
SELECT
    count(*) as `кол-во заказов`,
    buyer,
    (select name from users u where id = buyer) as `name`,
    (select phone from users u where id = buyer) as `phone`,
    (select email from users u where id = buyer) as `email`
from orders
group BY buyer
order by count(*) DESC ;

SELECT * from orders_buyer_count;


-- 3) Посмотреть все заказы пользователя для отрисовки в UI Мои заказы
-- сделала select через JOIN

set @buyer_id = 3;
SELECT
    o.id as `order_id`,
    p2.name as `id_product`,
    op.`count` as `кол-во`,
    o.status as `Статус заказа`,
    u.name as `Покупатель`,
    u.phone as `Телефон покупателя`,
    u.email as `User email`
from orders o
         join users u ON o.buyer = u.id
         join order_products op on o.id = op.order_id
         join products p2 on p2.id = op.product_id
where o.buyer = @buyer_id
ORDER BY o.id;


-- 3.1) посмотреть сколько товаров в определенном заказе количество

SELECT
    count(*) as cnt,
    o.id as `order_id`,
    o.status as `Статус заказа`,
    u.name as `name`,
    u.phone as `Телефон покупателя`,
    u.email as `User email`
from orders o
         join users u ON o.buyer = u.id
         join order_products op on o.id = op.order_id

GROUP by o.id
order by cnt DESC;

-- 3.2) Посмотреть количество заказов у конкретного пользователя

SELECT
    count(*) as cnt,
    u.name
from users u
         join orders o on u.id = o.buyer
group BY u.id
ORDER BY cnt DESC;


-- 4) Для админа view посмотреть все денежные средства пользователей,
--      чтобы отправить предложение потратить деньги

CREATE OR REPLACE VIEW show_money_users as

select
    u.name,
    uba.money
from user_bank_account uba
         join users u on uba.user_id = u.id
WHERE u.name <> 'admin'
order by money DESC;

SELECT * FROM show_money_users;