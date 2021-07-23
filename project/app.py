from re import S
from flask import Flask


def create_app():


    app = Flask(__name__, instance_relative_config=True)

    app.config.from_object('config.setting')
    app.config.from_pyfile('settings.py', silent=True)


    @app.route('/')
    def index():
        return "hello World"


    return app 
