FROM python:3
USER root
COPY . .
RUN pip install flask flask_cors
RUN pip install -r requirements.txt
EXPOSE 1003
CMD ["python","index.py"]
