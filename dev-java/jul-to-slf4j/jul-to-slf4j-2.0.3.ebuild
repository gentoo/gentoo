# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/qos-ch/slf4j/archive/v_2.0.3.tar.gz --slot 0 --keywords "~amd64" --ebuild jul-to-slf4j-2.0.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.slf4j:jul-to-slf4j:2.0.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JUL to SLF4J bridge"
HOMEPAGE="https://www.slf4j.org"
SRC_URI="https://github.com/qos-ch/slf4j/archive/v_${PV}.tar.gz -> slf4j-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Common dependencies
# POM: pom.xml
# org.slf4j:slf4j-api:2.0.3 -> >=dev-java/slf4j-api-2.0.3:0

CP_DEPEND="~dev-java/slf4j-api-${PV}:0"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.slf4j:slf4j-reload4j:2.0.3 -> >=dev-java/slf4j-reload4j-2.0.3:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		~dev-java/slf4j-reload4j-${PV}:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( ../{README,SECURITY}.md )

S="${WORKDIR}/slf4j-v_${PV}/${PN}"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,slf4j-reload4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
