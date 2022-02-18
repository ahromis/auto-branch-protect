FROM almir/webhook
RUN apk add --no-cache bash curl ca-certificates
RUN mkdir -p /var/run/webhooks
COPY hooks/hooks.json /etc/webhook/hooks.json
COPY scripts/branch-protection.sh /var/run/webhooks/branch-protection.sh
CMD ["-verbose", "-hooks=/etc/webhook/hooks.json", "-hotreload", "-template"]
