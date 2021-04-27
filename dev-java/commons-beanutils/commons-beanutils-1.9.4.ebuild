# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/beanutils/source/1.9.4-src.tar.gz --slot 1.7 --keywords "~amd64 ~x86 ~ppc64 ~amd64-linux ~x86-linux ~x64-macos" --ebuild commons-beanutils-1.9.4.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-beanutils:commons-beanutils:1.9.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provides easy-to-use wrappers around Reflection and Introspection APIs"
HOMEPAGE="https://commons.apache.org/proper/commons-beanutils/"
SRC_URI="mirror://apache/commons/beanutils/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

# Common dependencies
# POM: pom.xml
# commons-collections:commons-collections:3.2.2 -> >=dev-java/commons-collections-3.2.2:0
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CDEPEND="
	dev-java/commons-collections:0
	dev-java/commons-logging:0
"

# Compile dependencies
# POM: pom.xml
# test? commons-collections:commons-collections-testframework:3.2.1 -> !!!artifactId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.12:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-java/commons-collections:0[test]
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="iso-8859-1"

JAVA_GENTOO_CLASSPATH="commons-collections,commons-logging"
JAVA_SRC_DIR="src/main/java"
#	JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="commons-collections,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	"org.apache.commons.beanutils.TestBeanPublicSubclass"	# Invalid test class
	"org.apache.commons.beanutils.TestBeanPackageSubclass"	# Invalid test class
	"org.apache.commons.beanutils.TestResultSetMetaData"	# Invalid test class
	"org.apache.commons.beanutils.TestResultSet"	# Test class can only have one constructor
	"org.apache.commons.beanutils.TestBean"	# Test class can only have one constructor
)
