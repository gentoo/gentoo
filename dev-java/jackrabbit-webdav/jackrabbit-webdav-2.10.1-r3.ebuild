# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN/-*/}"

DESCRIPTION="Fully conforming implementation of the JRC API (specified in JSR 170 and 283)"
HOMEPAGE="https://jackrabbit.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${PV}/${MY_PN}-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

S="${WORKDIR}/${MY_PN}-${PV}/${PN}"

CP_DEPEND="dev-java/bndlib:0
	dev-java/slf4j-api:0
	dev-java/slf4j-nop:0
	dev-java/commons-httpclient:3
	dev-java/tomcat-servlet-api:2.3"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=( "src/main/resources" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )

src_test() {
	# Run only tests that would be executed by Maven as in ${S}/pom.xml:79
	JAVA_TEST_RUN_ONLY=$(find "${JAVA_TEST_SRC_DIR}" -name "*TestAll.java" \
		-exec realpath --relative-to="${JAVA_TEST_SRC_DIR}" {} \;)
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
