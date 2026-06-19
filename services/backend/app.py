from flask import Flask, jsonify

from config import settings

app = Flask(__name__)


@app.get("/api/health")
def health():
    return jsonify(
        status="ok",
        service=settings.SERVICE_NAME,
        version=settings.APP_VERSION,
        debug=settings.DEBUG,
    )


@app.get("/api/hello")
def hello():
    return jsonify(
        message=settings.GREETING_MESSAGE,
        service=settings.SERVICE_NAME,
        version=settings.APP_VERSION,
    )


@app.get("/api/config")
def config_preview():
    return jsonify(
        service=settings.SERVICE_NAME,
        version=settings.APP_VERSION,
        debug=settings.DEBUG,
        greeting=settings.GREETING_MESSAGE,
        api_key_set=bool(settings.API_KEY),
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=settings.DEBUG)
