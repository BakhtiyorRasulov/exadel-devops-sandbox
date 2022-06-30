FROM ubuntu:latest

RUN apt update && apt upgrade -y
RUN apt install nginx curl -y
ENV DEVOPS=bakhtiyor
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]