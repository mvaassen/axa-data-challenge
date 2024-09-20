import sqlite3

# Define SQL statements
SQL_CREATE_STRUCTURE = ""

def initializeDB(path):



# Connect to SQLite DB
with sqlite3.connect("../raw data/TestDB") as con:

    cur = con.cursor()

    cur.execute("""SELECT * FROM FREMTPL2FREQ
    LEFT JOIN FREMTPL2SEV
    ON IDpol = IDpol2
    WHERE ClaimNb = 0 OR IDpol2 IS NOT NULL""")

    print(cur.fetchone())

# Clean up
con.close()