FROM nginx
LABEL maintainer="Databricks"
ADD index.html /usr/share/nginx/html/index.html
EXPOSE 80