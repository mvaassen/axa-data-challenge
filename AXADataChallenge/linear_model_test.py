import sqlite3
import pandas as pd
import statsmodels
from sklearn.decomposition import PCA
from sklearn.linear_model import LinearRegression
import statsmodels.formula.api as sm


# Connect to SQLite DB
with sqlite3.connect("../raw data/TestDB") as con:

    cur = con.cursor()

    qry = """SELECT ClaimNb, VehPower, VehAge, DrivAge, COALESCE(ClaimAmount, 0) AS ClaimAmount FROM FREMTPL2FREQ
    LEFT JOIN FREMTPL2SEV
    ON IDpol = IDpol2
    WHERE ClaimNb = 0 OR IDpol2 IS NOT NULL"""

    df = pd.read_sql_query(qry, con)

    # Independent vars
    x = df[["ClaimNb", "VehPower", "VehAge", "DrivAge"]]

    # Response var
    y = df["ClaimAmount"]

    fitols = sm.ols(formula="ClaimAmount ~ ClaimNb + DrivAge", data=df)
    regresult = fitols.fit()

    print(regresult.summary())

    # pca = PCA(n_components=3)
    # pca.fit(df)

    #print(pca.explained_variance_ratio_)

# Clean up
con.close()
