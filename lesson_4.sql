/* 2) Написать скрипт, возвращающий список имен
(только firstname) пользователей без повторений
в алфавитном порядке */
USE vk;
SELECT DISTINCT firstname FROM users ORDER BY firstname;

/*3)Первые пять пользователей пометить как удаленные.*/
UPDATE users
SET is_deleted = 1
LIMIT 5;

/*4) Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)*/
INSERT INTO messages (from_user_id, to_user_id, body, created_at) VALUES ('1', '2', 'Lorem', '2021-01-01'),
										('3', '4', 'Lorem10', '2022-05-05'),
										('3', '4', 'Lorem10', '2022-05-05'),
										('3', '4', 'Lorem10', '2022-05-05');



DELETE FROM messages WHERE
created_at > CURRENT_DATE();