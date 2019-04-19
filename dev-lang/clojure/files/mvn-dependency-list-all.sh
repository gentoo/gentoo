#!/bin/bash

# "Good style" would be to use "dependency" to get the version bundled with
# Maven, but then (as of Maven 3.6.0) we would get an old version with bugs
# and missing features.  Thus force version 3.1.1 for now.
mvn_dependency=org.apache.maven.plugins:maven-dependency-plugin:3.1.1

mvn \
	-DincludeParents=true \
	-DoutputFile=>(cat) \
	"${mvn_dependency}":resolve \
	"${mvn_dependency}":resolve-plugins > /dev/null \
	| grep -v -e '^The following .* have been resolved:$' -e '^$' \
	| sed 's/^[[:space:]]*//' \
	| awk -F: '$3 != "maven-plugin" && NF >= 5 { print $1":"$2":"$3":"$4":"$5 } $3 != "maven-plugin" && NF <= 4 { print $1":"$2":"$3":"$4 }' \
	| sort -u
