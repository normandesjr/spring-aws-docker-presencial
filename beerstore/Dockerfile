FROM openjdk:8u171-jdk-alpine3.8
LABEL maintainer="normandesjr@gmail.com"

ENV LANG C.UTF-8

RUN apk add --update bash

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

ADD build/libs/*.jar /app/app.jar

EXPOSE 8080
HEALTHCHECK --start-period=10s --timeout=3s CMD wget -q -O /dev/null http://localhost:8080/actuator/health || exit 1

CMD [ "/app/app.jar" ]