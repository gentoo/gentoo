# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://artfiles.org/apache.org//commons/validator/source/commons-validator-1.7-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-validator-1.7.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-validator:commons-validator:1.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Commons component to validate user input, or data input"
HOMEPAGE="https://commons.apache.org/proper/commons-validator/"
SRC_URI="mirror://apache/commons/validator/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# commons-beanutils:commons-beanutils:1.9.4 -> >=dev-java/commons-beanutils-1.9.4:1.7
# commons-collections:commons-collections:3.2.2 -> >=dev-java/commons-collections-3.2.2:0
# commons-digester:commons-digester:2.1 -> >=dev-java/commons-digester-2.1:2.1
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CDEPEND="
	dev-java/commons-beanutils:1.7
	dev-java/commons-digester:2.1
	dev-java/commons-logging:0
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.1:4
# test? org.apache.commons:commons-csv:1.6 -> dev-java/commons-csv:0
# test? org.bitstrings.test:junit-clptr:1.2.2 -> dev-java/junit-clptr:0
#
# restricting for compilation to jdk 1.8 just because of tests which
# are not adjusted by upstream for jdk 11, otherwise the package works fine with jdk 11

DEPEND="${CDEPEND}
	virtual/jdk:1.8
	test? (
		dev-java/commons-csv:0
		dev-java/junit-clptr:0
	)
"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${P}-src"

JAVA_GENTOO_CLASSPATH="commons-beanutils-1.7,commons-digester-2.1,commons-logging"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="commons-csv,junit-4,junit-clptr"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
