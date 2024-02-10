# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.ongres.scram:client:2.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Implementation of the Salted Challenge Response Authentication Mechanism"
HOMEPAGE="https://gitlab.com/ongresinc/scram"
SRC_URI="https://gitlab.com/ongresinc/${PN}/-/archive/${PV}/${P}.tar.bz2"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

CP_DEPEND="dev-java/saslprep:0"

DEPEND="${CP_DEPEND}
	dev-java/findbugs-annotations:0
	dev-java/jsr305:0
	>=virtual/jdk-1.8:*
	test? ( dev-java/stringprep:0 )
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( CHANGELOG NOTICE README.md )

JAVADOC_CLASSPATH="
	findbugs-annotations
	saslprep
"
JAVADOC_SRC_DIRS=(
	"common/src/main/java"
	"client/src/main/java"
)
JAVA_CLASSPATH_EXTRA="findbugs-annotations,jsr305"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,stringprep"

src_compile() {
	einfo "Compiling module common"
	JAVA_SRC_DIR="common/src/main/java"
	JAVA_JAR_FILENAME="common.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":common.jar"
	rm -r target || die

	einfo "Compiling module client"
	JAVA_SRC_DIR="client/src/main/java"
	JAVA_JAR_FILENAME="client.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":client.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_test() {
	cp -r {common,client}/src/test/java || die

	einfo "Testing module cwclientcommon"
	JAVA_TEST_SRC_DIR="client/src/test/java"
	java-pkg-simple_src_test
}

src_install() {
	JAVA_JAR_FILENAME="client.jar"
	java-pkg-simple_src_install
	java-pkg_dojar "common.jar"
	if use source; then
		java-pkg_dosrc "common/src/main/java/*"
		java-pkg_dosrc "client/src/main/java/*"
	fi
}
