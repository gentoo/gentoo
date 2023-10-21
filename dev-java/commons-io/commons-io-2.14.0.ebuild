# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-io:commons-io:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Utility classes, stream implementations, file filters, and much more"
HOMEPAGE="https://commons.apache.org/proper/commons-io/"
SRC_URI="mirror://apache/commons/io/source/${P}-src.tar.gz
	test? ( https://repo1.maven.org/maven2/org/junit-pioneer/junit-pioneer/1.9.1/junit-pioneer-1.9.1.jar )
	verify-sig? ( https://archive.apache.org/dist/commons/io/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64"
RESTRICT="test" #839681

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-lang:3.6
		dev-java/guava:0
		dev-java/jimfs:0
		dev-java/jmh-core:0
		dev-java/jmh-generator-annprocess:0
		dev-java/mockito:4
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.io"
JAVA_ENCODING="iso-8859-1"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	commons-lang-3.6
	guava
	jimfs
	jmh-core
	jmh-generator-annprocess
	junit-4
	junit-5
	mockito-4
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}/${P}"-src.tar.gz{,.asc}
	fi
	unpack ${P}-src.tar.gz
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA=":${DISTDIR}/junit-pioneer-1.9.1.jar"
	java-pkg-simple_src_test
}
