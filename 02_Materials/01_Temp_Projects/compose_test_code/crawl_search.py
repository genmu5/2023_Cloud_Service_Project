import pymysql

conn = pymysql.connect(
    host = 'localhost',
    user = 'root',
    password = '1234',
    db = 'testDB',
    charset = 'utf8'
)

curs = conn.cursor()

sql = "SELECT IDX, TEST FROM member_table"
curs.execute(sql)
result = curs.fetchall()
print("현재 테이블의 데이터수는 총 {}개 입니다.".format(len(result)))
