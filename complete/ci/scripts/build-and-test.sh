#!/bin/sh
set -ex
cd git-repo/complete

#export MAVEN_USER_HOME=$(cd maven-cache && pwd)
export COMPONENT_NAME=gs-multi-module
export module_1=multi-module-application-complete
export module_2=library-complete
export PRODUCT_NAME=com.renodesor.multimodule
export MAVEN_ARGS="-Dmaven.repo.local=../maven-cache/repository ${MAVEN_ADDITIONAL_ARGS}"
	echo No commit : $(git rev-parse --short HEAD)
	./mvnw -version
	if [[ -z "${VERSION}" ]]; then
		echo version 1: ${VERSION}
#		VERSION=$(echo "$(date +'%Y%m%d%H%M%S')-$(git rev-parse --short HEAD)") 
		VERSION=1.0.0-build.$(echo "$(date +'%Y%m%d%H%M%S')")
	fi 

#	echo "${VERSION}" > ../distribution-repository/version
#	cat ../distribution-repository/version
	
	#Verifier si jacoco-maven-plugin est présent dans pom.xml pour lancer le build
	
	MVN_GOAL="package"
#	if `./mvnw help:effective-pom $MAVEN_ARGS "${MAVEN_ADDITIONAL_ARGS_ARRAY[@]}" | grep -q jacoco-maven-plugin`; then
#		MVN_GOAL="jacoco:prepare-agent $MVN_GOAL jacoco:report" 
#	fi 
	MAVEN_ARGS="$MAVEN_ARGS -Drevision=${VERSION} versions: set-property -Dproperty=revision -DnewVersion=${VERSION}"
	echo MAVEN_ARGS:${MAVEN_ARGS}
	echo MVN_GOAL:${MVN_GOAL}
	echo VERSION:${VERSION}
	
	# Ajout de la version dans la variable revision, tant pour l'exécution actuelle que pour 1 
	#MVN_GOAL="$MVN_GOAL -Drevision=${VERSION} versions: set-property -Dproperty=revision -DnewVersion=${VERSION} -DgenerateBackupPoms=false" 
	echo "Début du Build maven"
	./mvnw clean package -Drevision=${VERSION}  versions:set-property -Dproperty=revision -DnewVersion=${VERSION} -DgenerateBackupPoms=false
	#"${MAVEN_ADDITIONAL_ARGS_ARRAY[@]}"
	echo "Fin du Build maven"
	
	echo -e "Copie du pom"
	
	cd ..
	
#	mkdir -p ../distribution-repository/${COMPONENT_NAME}/${VERSION}
#	mkdir -p ../distribution-repository/${module_1}/${VERSION}
#	mkdir -p ../distribution-repository/${module_2}/${VERSION}
	
	
#	cp pom.xml ../distribution-repository/${COMPONENT_NAME}/${VERSION}/${COMPONENT_NAME}-${VERSION}.pom
	cp complete/pom.xml ../distribution-repository/${COMPONENT_NAME}-${VERSION}.pom
#	cp application/pom.xml ../distribution-repository/${module_1}/${VERSION}/${module_1}-${VERSION}.pom
#	cp library/pom.xml ../distribution-repository/${module_2}/${VERSION}/${module_2}-${VERSION}.pom
	cp complete/application/pom.xml ../distribution-repository/${module_1}-${VERSION}.pom
	cp complete/library/pom.xml ../distribution-repository/${module_2}-${VERSION}.pom
	
	# est-ce qu'il y a des artefacts à copier autres que le pom.xml? 
	
#	if  -G "target/${COMPONENT_NAME}-${VERSION}*.*" > /dev/null; then
		echo -e "Copie des autres artefacts" 
		cp complete/application/target/${module_1}-${VERSION}.jar ../distribution-repository/
		cp complete/library/target/${module_2}-${VERSION}.jar ../distribution-repository/
#		rm -f ../distribution-repository/${COMPONENT_NAME}/${VERSION}/*.original

	cd ../distribution-repository
		OUTPUT_FILE="${COMPONENT_NAME}-${VERSION}.tar.gz"
		touch $OUTPUT_FILE
		#zip -r $OUTPUT_FILE .
		tar -czvf $OUTPUT_FILE .
		rm -f *.pom
		rm -f *.jar
		
		echo -e "List distribution-repository" 
		ls -l ../distribution-repository
		
#	fi 
cd ..

