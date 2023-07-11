# file name : dbModule.py
# pwd : /project_name/app/module/dbModule.py
 
import pymysql
 
class Database():
    def __init__(self):
        self.db = pymysql.connect(host='127.0.0.1:3306',
                                  user='user',
                                  password=123456,
                                  db='db_1',
                                  charset='utf8')
        self.cursor = self.db.cursor(pymysql.cursors.DictCursor)
 
    def execute(self, query, args={}):
        self.cursor.execute(query, args)
 
    def executeOne(self, query, args={}):
        self.cursor.execute(query, args)
        row = self.cursor.fetchone()
        return row
 
    def executeAll(self, query, args={}):
        self.cursor.execute(query, args)
        row = self.cursor.fetchall()
        return row
 
    def commit():
        self.db.commit()