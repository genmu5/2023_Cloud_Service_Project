-- file name : test.sql
-- pwd : /project_name/app/schema/test.sql
 
CREATE DATABASE testDB default CHARACTER SET UTF8;
 
use testDB;
 
CREATE TABLE member_table (
    idx      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    test     VARCHAR(256) NOT NULL
) CHARSET=utf8;
