# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.java.dev.msv:msv-core:2022.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Multi-Schema Validator Core package"
HOMEPAGE="https://xmlark.github.io/msv/core/"
SRC_URI="https://github.com/xmlark/msv/archive/msv-${PV}.tar.gz"
S="${WORKDIR}/msv-${P}/msv"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	dev-java/iso-relax:0
	dev-java/relaxng-datatype:0
	dev-java/xml-commons-external:1.4
	dev-java/xml-commons-resolver:0
	dev-java/xsdlib:0
"

DEPEND=">=virtual/jdk-1.8:*
	dev-java/xerces:2
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

JAVA_CLASSPATH_EXTRA="xerces-2"
JAVA_MAIN_CLASS="com.sun.msv.driver.textui.Driver"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# Selection according to pom.xml#L182-L210
	local JAVA_TEST_RUN_ONLY=$(find src/test/java \
		\( -name "*Test.java" \
		-o -name "*TestCase.java" \
		-o -name "*TestCases.java" \) \
		! -name "*\$*" -printf "%P\n")
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
