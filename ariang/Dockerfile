FROM httpd:2.4

RUN rm -rf /usr/local/apache2/htdocs/*

RUN curl -sL https://github.com/mayswind/AriaNg/releases/download/1.3.3/AriaNg-1.3.3.zip -o /tmp/ariang.zip && \
    unzip -q /tmp/ariang.zip -d /usr/local/apache2/htdocs/ && \
    rm /tmp/ariang.zip

RUN echo '
ServerName localhost
Listen 8080
' >> /usr/local/apache2/conf/httpd.conf

ENV ARIA2_HOST=localhost
ENV ARIA2_PORT=6800

RUN cat > /usr/local/bin/init-ariang.sh << 'EOF'
#!/bin/sh

if [ -n "$ARIA2_SECRET" ]; then
    sed -i "s/aria2\.rpc\.secret = ''/aria2.rpc.secret = '$ARIA2_SECRET'/" /usr/local/apache2/htdocs/*.html
fi

if [ -n "$ARIA2_HOST" ]; then
    sed -i "s/aria2\.rpc\.host = '127\.0\.0\.1'/aria2.rpc.host = '$ARIA2_HOST'/" /usr/local/apache2/htdocs/*.html
fi

if [ -n "$ARIA2_PORT" ]; then
    sed -i "s/aria2\.rpc\.port = '6800'/aria2.rpc.port = '$ARIA2_PORT'/" /usr/local/apache2/htdocs/*.html
fi

exec httpd-foreground
EOF
RUN chmod +x /usr/local/bin/init-ariang.sh

EXPOSE 8080

CMD ["/usr/local/bin/init-ariang.sh"]