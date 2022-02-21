FROM python:3.10-alpine

MAINTAINER Phong Hua

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

# Install postgresql client
RUN apk add --update --no-cache postgresql-client
# Install temporary requirements into .tmp-build-dev folder
RUN apk add --update --no-cache --virtual .tmp-build-dev \
    gcc libc-dev linux-headers postgresql-dev

# Take requirements we just copy and install them into docker image
RUN pip install -r /requirements.txt

# Delete temp requirements we install before
RUN apk del .tmp-build-dev

# Create empty folder /app on docker image
RUN mkdir /app

# Choose /app as default working directory
WORKDIR /app

# Copy the app folder on local machine to app folder on image
COPY ./app /app

# Create a user to run the app only
RUN adduser -D user
# Switch to that user
USER user