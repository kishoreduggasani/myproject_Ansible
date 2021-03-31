#building calculator image using maven and tomcat
From maven:3.6.2 as calc_build_maven
workdir /app
copy . .
run mvn package -e
# deploy war file to tomcat from calc_build_maven
FROM tomcat:8.0
COPY --from=calc_build_maven /app/target/*.war /usr/local/tomcat/webapps/

