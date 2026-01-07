# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.java.dev.msv:xsdlib:2022.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Schema datatypes library"
HOMEPAGE="https://github.com/xmlark/msv/tree/main/xsdlib"
SRC_URI="https://github.com/xmlark/msv/archive/msv-${PV}.tar.gz"
S="${WORKDIR}/msv-msv-${PV}/xsdlib"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

CP_DEPEND="dev-java/relaxng-datatype:0"

DEPEND="
	dev-java/xerces:2
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/jdom:2
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

JAVA_CLASSPATH_EXTRA="xerces-2"
JAVA_MAIN_CLASS="com.sun.msv.datatype.xsd.CommandLineTester"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,jdom-2"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# Selection according to pom.xml#L156-L184
	local JAVA_TEST_RUN_ONLY=$(find src/test/java \
		\( -name "*Test.java" \
		-o -name "*TestCase.java" \
		-o -name "*TestCases.java" \) \
		! -name "*\$*" -printf "%P\n")
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
