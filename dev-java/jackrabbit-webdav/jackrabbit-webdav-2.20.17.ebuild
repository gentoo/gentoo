# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

MY_PN="${PN/-*/}"

DESCRIPTION="Fully conforming implementation of the JRC API (specified in JSR 170 and 283)"
HOMEPAGE="https://jackrabbit.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${PV}/${MY_PN}-${PV}-src.zip
	verify-sig? ( mirror://apache/${MY_PN}/${PV}/${MY_PN}-${PV}-src.zip.asc )"
S="${WORKDIR}/${MY_PN}-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="2.20"
KEYWORDS="~amd64 ~ppc64"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-jackrabbit )
"
CP_DEPEND="
	dev-java/httpcomponents-client:4
	dev-java/javax-servlet-api:3.1
	dev-java/slf4j-api:0
	dev-java/slf4j-nop:0
"
DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/bndlib:0
	${CP_DEPEND}
"
RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

JAVA_CLASSPATH_EXTRA="bndlib"
JAVA_RESOURCE_DIRS=( "src/main/resources" )
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/jackrabbit-apache.org.asc"

src_test() {
	# Run only tests that would be executed by Maven as in ${S}/pom.xml:79
	JAVA_TEST_RUN_ONLY=$(find "${JAVA_TEST_SRC_DIR}" -name "*TestAll.java" --printf '%P\n')
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
