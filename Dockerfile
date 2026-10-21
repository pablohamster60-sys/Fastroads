FROM python:3.12-slim AS build

WORKDIR /app
COPY fastroads-source-posix.zip /tmp/fastroads-source-posix.zip
RUN python -c "import zipfile; zipfile.ZipFile('/tmp/fastroads-source-posix.zip').extractall('/app')"

FROM python:3.12-slim

WORKDIR /app
COPY --from=build /app/ /app/

ENV FASTROADS_HOST=0.0.0.0
ENV PYTHONUNBUFFERED=1

CMD ["python", "multiplayer_server.py"]
