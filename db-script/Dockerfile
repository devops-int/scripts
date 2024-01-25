FROM python:3.8
WORKDIR /app
COPY . /app
RUN pip install requests
RUN pip install mysql-connector-python
CMD ["python3", "./check.py"]