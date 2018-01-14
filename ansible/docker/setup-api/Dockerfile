FROM maven:3.3.9-jdk-8

ENV api_name setup-api
ENV jar_location ./app

RUN echo "==> Running: " ${api_name}
ADD ${jar_location}/${api_name}.jar /opt/target/
CMD java -jar -Dspring.profiles.active=dev /opt/target/${api_name}.jar

EXPOSE 8095
