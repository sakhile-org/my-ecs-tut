FROM python:3.8-slim

#add a user
#prevents running sudo commands
RUN useradd -r -s /bin/bash sakhile

ENV HOME /app

WORKDIR /app
ENV PATH="/app/.local/bin:${PATH}"

RUN chown -R sakhile:sakhile /app
USER sakhile

#set app config option
ENV FLASK_ENV=production

#set arguments vars in docker run command
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

ENV AWS_ACCESS_KEY_ID AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py ./app
WORKDIR /app

CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app", "--workers=5"]
