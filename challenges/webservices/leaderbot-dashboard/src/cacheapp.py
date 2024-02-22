import pylibmc
import uuid
from cachelib import SimpleCache
from flask_session import Session
from flask import Flask, session, request, redirect
from authlib.jose import jwt, JsonWebKey
import sys, json
import sqlite3

from jinja2 import Environment, PackageLoader, select_autoescape
env = Environment(
    loader=PackageLoader("cacheapp"),
    autoescape=select_autoescape()
)

USERNAME_FIELD = 'username'
PASSWORD_FIELD = 'password'


app = Flask(__name__)
app.secret_key = "Dashboard42!"
app.config["SESSION_TYPE"] = "memcached"
app.config["SESSION_USE_SIGNER"] = True
Session(app)

# Database
conn = sqlite3.connect('file::memory:?cache=shared', check_same_thread=False)



@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


@app.route("/success")
def get():
    try:
        username = session.get("username")
        if username:
            template = env.get_template("success.html")
            rendered = template.render(USERNAME_FIELD=USERNAME_FIELD, PASSWORD_FIELD=PASSWORD_FIELD, message="Welcome")
            return rendered
        else:
            return redirect("/")
    except:
        return redirect("/")



@app.route("/login", methods=["POST"])
def login():

    returnData = {'result':'false'}

    try:
        data = request.json

        if len(data[USERNAME_FIELD]) > 100:
            return {'result':'false'}

        # Get username
        cur = conn.cursor()
        query = "SELECT token from tokens where token = ?"
        cur.execute(query, (data[USERNAME_FIELD],))
        ret = cur.fetchone()
        
        # Check token for user
        if ret == data[PASSWORD_FIELD]:
            returnData['result'] = 'success'
            session[USERNAME_FIELD] = data[USERNAME_FIELD]
        
    except:
       returnData = {'result':'false'}

    return returnData


@app.route("/")
def main():
    template = env.get_template("index.html")
    rendered = template.render(USERNAME_FIELD=USERNAME_FIELD, PASSWORD_FIELD=PASSWORD_FIELD, message="Welcome")
    return rendered


if __name__ == "__main__":

    cur = conn.cursor()
    cur.execute("""
        create table tokens(
            id integer primary key autoincrement not null,
            username text,
            token text
        );
    """)
    # small chance someone actually guesses this
    cur.execute("insert into tokens (username, token) VALUES (\"leaderbot\",\"f054bbd2f5ebab9cb5571000b2c50c02\");")
    conn.commit()
    

    app.run(host="0.0.0.0", port=8000, debug=False)