FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    U13MF_APP_ROOT=/app \
    U13MF_PROFILES=/app/profiles \
    U13MF_USER_PROFILES=/app/user_profiles \
    U13MF_BAMBU_PROFILES=/app/bambu_profiles \
    U13MF_RULES=/app/rules \
    U13MF_TMP=/app/tmp \
    U13MF_FAILED_TMP=/app/tmp_failed \
    U13MF_FEEDBACK=/app/feedback \
    U13MF_FRONTEND_DIST=/app/frontend \
    BAMBU2SNAP_PORT=8080

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend ./backend
COPY frontend ./frontend
COPY profiles ./profiles
COPY rules ./rules
RUN mkdir -p tmp tmp_failed feedback user_profiles bambu_profiles

WORKDIR /app/backend
EXPOSE 8080
CMD ["sh", "-c", "exec uvicorn main:app --host 0.0.0.0 --port ${BAMBU2SNAP_PORT}"]
