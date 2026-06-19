from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Публичные — дефолты в коде
    SERVICE_NAME: str = "backend"
    VERSION: str = "1.0.0"
    DEBUG: bool = False
    GREETING_MESSAGE: str = "Привет от backend!"

    # Секреты — поля = ключи в secrets/backend.secret.env → K8s Secret
    API_KEY: str = ""
    DATABASE_URL: str = ""
    RABBITMQ_USER: str = ""
    RABBITMQ_PASS: str = ""
    CASE_SERVICE_KEY: str = ""
    USER_SERVICE_KEY: str = ""

    model_config = SettingsConfigDict(
        env_file=None,
        extra="ignore",
    )


settings = Settings()
