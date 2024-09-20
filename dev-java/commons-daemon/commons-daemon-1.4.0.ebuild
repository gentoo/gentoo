# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-daemon:commons-daemon:${PV}"

inherit java-pkg-2 java-pkg-simple toolchain-funcs verify-sig

DESCRIPTION="Tools to allow Java programs to run as UNIX daemons"
HOMEPAGE="https://commons.apache.org/proper/commons-daemon/"
SRC_URI="mirror://apache/commons/daemon/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/daemon/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {HOWTO-RELEASE,NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( PROPOSAL.html )
PATCHES=( "${FILESDIR}/commons-daemon-1.3.1-Make.patch" )

JAVA_ENCODING="iso-8859-1"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	JAVA_JAR_FILENAME="org.apache.${PN}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	jdeps --generate-module-info \
		src/main/java \
		--multi-release 9 \
		"${JAVA_JAR_FILENAME}" || die

	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile	# creates the final jar file including module-info

	pushd src/native/unix || die
		./configure
		emake AR="$(tc-getAR)"
	popd
}

src_install() {
	java-pkg-simple_src_install
	dobin src/native/unix/jsvc
}
