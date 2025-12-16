# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="SCRAM (RFC 5802) Java implementation"
HOMEPAGE="https://github.com/ongres/scram"
SRC_URI="https://github.com/ongres/scram/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	>=dev-java/jetbrains-annotations-26.0.2.1:0
	>=dev-java/stringprep-2.2:0
"

DEPEND="
	${CP_DEPEND}
	dev-java/findbugs-annotations:0
	dev-java/jsr305:0
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( CHANGELOG.md README.md )

JAVADOC_CLASSPATH="findbugs-annotations jetbrains-annotations stringprep"
JAVADOC_SRC_DIRS=( scram-{common,client}/src/main/java )
JAVA_CLASSPATH_EXTRA="findbugs-annotations jetbrains-annotations jsr305 stringprep"
JAVA_TEST_GENTOO_CLASSPATH="junit-5 stringprep"

src_compile() {
	einfo "Compiling module common"
	JAVA_SRC_DIR="scram-common/src/main/java"
	JAVA_JAR_FILENAME="common.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":common.jar"
	rm -r target || die

	einfo "Compiling module client"
	JAVA_SRC_DIR="scram-client/src/main/java"
	JAVA_JAR_FILENAME="client.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":client.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_test() {
	einfo "Testing scram-common"
	JAVA_TEST_SRC_DIR="scram-common/src/test/java"
	junit5_src_test

	einfo "Testing scram-client"
	JAVA_TEST_RESOURCE_DIRS="scram-client/src/test/resources"
	JAVA_TEST_SRC_DIR="scram-client/src/test/java"
	junit5_src_test
}

src_install() {
	JAVA_JAR_FILENAME="client.jar"
	java-pkg-simple_src_install
	java-pkg_dojar "common.jar"
	if use source; then
		java-pkg_dosrc "scram-common/src/main/java/*"
		java-pkg_dosrc "scram-client/src/main/java/*"
	fi
}
