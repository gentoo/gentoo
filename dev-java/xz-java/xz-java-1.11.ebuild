# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Implementation of xz data compression in pure java"
HOMEPAGE="https://tukaani.org/xz/java.html"
SRC_URI="https://tukaani.org/xz/${P}.zip
	verify-sig? ( https://tukaani.org/xz/${P}.zip.sig )"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-lassecollin )
"
DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {AUTHORS,NEWS,README,THANKS}.md )
JAVA_INTERMEDIATE_JAR_NAME="org.tukaani.xz"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src9" )
JAVA_SRC_DIR="src"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/lassecollin.asc"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir demo test || die "mkdir"
	mv src/*Demo.java demo || die "mv *Demo"
	mv src/TestAllocSpeed.java test || die "mv *Test*"
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples demo/*Demo.java
}
