
FROM tomcat:latest

MAINTAINER A Gorla

COPY ./webapp/target/webapp.war /usr/local/tomcat/webapps

