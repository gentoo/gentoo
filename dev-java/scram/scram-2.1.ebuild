# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom common/pom.xml --download-uri https://gitlab.com/ongresinc/scram/-/archive/2.1/scram-2.1.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild scram-2.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.ongres.scram:common:2.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Implementation of the Salted Challenge Response Authentication Mechanism"
HOMEPAGE="https://gitlab.com/ongresinc/scram"
SRC_URI="https://gitlab.com/ongresinc/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: common/pom.xml
# com.ongres.stringprep:saslprep:1.1 -> >=dev-java/stringprep-2.0:0

CP_DEPEND="
	dev-java/saslprep:0
"

# Compile dependencies
# POM: common/pom.xml
# com.google.code.findbugs:annotations:3.0.1 -> !!!artifactId-not-found!!!
# com.google.code.findbugs:jsr305:3.0.1 -> >=dev-java/jsr305-3.0.2:0
# POM: common/pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	dev-java/findbugs-annotations:0
	dev-java/jsr305:0
	test? ( dev-java/stringprep:0 )
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( CHANGELOG NOTICE README.md )

S="${WORKDIR}/${P}"

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

	if use doc; then
		einfo "Compiling javadocs"
		JAVA_SRC_DIR=(
			"common/src/main/java"
			"client/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	einfo "Testing module common"
	JAVA_TEST_SRC_DIR="common/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing module cwclientcommon"
	JAVA_TEST_SRC_DIR="client/src/test/java"
	java-pkg-simple_src_test
}

src_install() {
	default
	java-pkg_dojar "common.jar"
	java-pkg_dojar "client.jar"
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	if use source; then
		java-pkg_dosrc "common/src/main/java/*"
		java-pkg_dosrc "client/src/main/java/*"
	fi
}
