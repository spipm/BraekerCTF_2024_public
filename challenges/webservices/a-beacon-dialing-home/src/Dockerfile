FROM python:alpine

WORKDIR /usr/src/app

RUN pip install phonenumbers unidecode jinja2 flask

COPY dialbeacon.py .

RUN mkdir ./templates

COPY dial.html ./templates/

EXPOSE 2000

CMD ["python", "dialbeacon.py"] 