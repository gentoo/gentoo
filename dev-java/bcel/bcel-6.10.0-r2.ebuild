# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.bcel:bcel:6.10.0"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Commons Bytecode Engineering Library"
HOMEPAGE="https://commons.apache.org/proper/commons-bcel/"
SRC_URI="https://downloads.apache.org/commons/bcel/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/bcel/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
CP_DEPEND=">=dev-java/commons-lang-3.17.0:3.6"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE.txt RELEASE-NOTES.txt )

JAVA_SRC_DIR="src/main/java"

src_compile() {
	JAVA_JAR_FILENAME="org.apache.${PN}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	jdeps \
		--module-path "$(java-pkg_getjars commons-lang-3.6)" \
		--add-modules org.apache.commons.lang \
		--generate-module-info \
		src/main/java \
		--multi-release 9 \
		"${JAVA_JAR_FILENAME}" || die

	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile	# creates the final jar file including module-info
}
