from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    SERVICE_NAME: str = "backend"
    DEBUG: bool = False
    GREETING_MESSAGE: str = "Привет от backend!"

    # Версия релиза — из services/backend/VERSION (CI → image tag)
    APP_VERSION: str = "0.0.0"

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
