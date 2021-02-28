-- Задание 1 отображено на PrtSc my_cnf
-- Задание 2
-- Создайте базу данных example, разместите в ней таблицу users, состоящую
-- из двух столбцов, числового id и строкового name.

CREATE DATABASE example;
USE example;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE
);

-- Задание 3
-- Создайте дамп базы данных example из предыдущего задания, разверните
-- содержимое дампа в новую базу данных sample.

-- Создаём дамп БД example
-- mysqldump example > example.sql

-- Создаём БД sample
-- mysql -e 'CREATE DATABASE sample'

-- Загружаем дамп в БД sample
-- mysql sample < example.sql

-- Задание 4
-- (по желанию) Ознакомьтесь более подробно с документацией утилиты
-- mysqldump. Создайте дамп единственной таблицы help_keyword базы данных
-- mysql. Причем добейтесь того, чтобы дамп содержал только первые 100
-- строк таблицы.


-- mysqldump mysql help_keyword where='TRUE ORDER BY help_keyword_id LIMIT 100' > help_keyword_report.sql
