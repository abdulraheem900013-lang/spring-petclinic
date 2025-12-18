FROM maven:3-amazoncorretto-17 AS builder
COPY . /spc
RUN cd /spc && mvn package

FROM amazoncorretto:17-alpine3.18-jar

LABEL environment="test" project="springpetclinic"

ARG USERNAME="spy"
ARG HOMEDIR="/sprigpetclinic"

RUN adduser -h ${HOMEDIR} -s /bin/bash -D ${USERNAME}

COPY --from=builder --chown=${USERNAME}:${USERNAME} /spc/target/spring-petclinic-*.jar ${HOMEDIR}/spring-petclinic-*.jar

USER ${USERNAME}

WORKDIR ${HOMEDIR}

EXPOSE 8080

CMD [ "sh", "-c", "jar spring-petclinic-*.jar"]