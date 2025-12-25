import os

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
    JWT_ACCESS_TOKEN_EXPIRES = False  # Set to appropriate value in production

    @property
    def SQLALCHEMY_DATABASE_URI(self):
        user = os.getenv('POSTGRES_USER')
        password = os.getenv('POSTGRES_PASSWORD')
        host = os.getenv('DB_HOST', 'localhost')
        port = os.getenv('DB_PORT', '5432')
        db_name = os.getenv('POSTGRES_DB')
        return f'postgresql://{user}:{password}@{host}:{port}/{db_name}'