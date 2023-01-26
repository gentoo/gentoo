# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/daemon/source/commons-daemon-1.3.3-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-daemon-1.3.3.ebuild

EAPI=8

# No tests because "package org.junit.jupiter.api does not exist"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-daemon:commons-daemon:1.3.3"

inherit java-pkg-2 java-pkg-simple toolchain-funcs verify-sig

DESCRIPTION="Tools to allow Java programs to run as UNIX daemons"
HOMEPAGE="https://commons.apache.org/proper/commons-daemon/"
SRC_URI="mirror://apache/commons/daemon/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/daemon/source/${P}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"

DOCS=( {CONTRIBUTING,README}.md {HOWTO-RELEASE,NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( PROPOSAL.html )
PATCHES=( "${FILESDIR}/commons-daemon-1.3.1-Make.patch" )

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="iso-8859-1"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	java-pkg-simple_src_compile

	pushd src/native/unix || die
		./configure
		emake AR="$(tc-getAR)"
	popd
}

src_install() {
	java-pkg-simple_src_install
	dobin src/native/unix/jsvc
}
