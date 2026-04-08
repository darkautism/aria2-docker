FROM httpd:2.4

RUN rm -rf /usr/local/apache2/htdocs/*

RUN curl -sL https://github.com/mayswind/AriaNg/releases/download/1.3.3/AriaNg-1.3.3.zip -o /tmp/ariang.zip && \
    unzip -q /tmp/ariang.zip -d /usr/local/apache2/htdocs/ && \
    rm /tmp/ariang.zip

RUN echo '
ServerName localhost
Listen 8080
' >> /usr/local/apache2/conf/httpd.conf

EXPOSE 8080

CMD ["httpd-foreground"]