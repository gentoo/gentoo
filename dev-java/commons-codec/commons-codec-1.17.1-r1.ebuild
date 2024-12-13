# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-codec:commons-codec:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Implementations of common encoders and decoders in Java"
HOMEPAGE="https://commons.apache.org/proper/commons-codec/"
SRC_URI="mirror://apache/commons/codec/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/codec/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~amd64-linux ~x86-linux"
RESTRICT="test" #839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/commons-lang:3.6
		dev-java/hamcrest:0
		dev-java/junit:5[migration-support]
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	junit-4
	junit-5
	commons-lang-3.6
	hamcrest
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_compile() {
	JAVA_JAR_FILENAME="org.apache.${PN}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	jdeps --generate-module-info \
		src/main/java \
		--multi-release 9 \
		"${JAVA_JAR_FILENAME}" || die

	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile	# creates the final jar file including module-info
}
