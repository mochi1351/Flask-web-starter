import os

# Database.
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://localhost/mydatabase")

# Development configuration.
class DevelopmentConfig:
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
    SQLALCHEMY_TRACK_MODIFICATIONS = False

# Production configuration.
class ProductionConfig:
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
    SQLALCHEMY_TRACK_MODIFICATIONS = False

# Determine which configuration to use.
if os.getenv("FLASK_ENV") == "production":
    app_config = ProductionConfig
else:
    app_config = DevelopmentConfig

