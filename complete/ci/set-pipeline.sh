#fly -t myprojects login --concourse-url=http://localhost:8080/
fly -t myprojects set-pipeline -p spring-security-auth -c pipeline.yml -l param.yml