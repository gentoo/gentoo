# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"
MAVEN_ID="org.tukaani:xz:1.9"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Implementation of xz data compression in pure java"
HOMEPAGE="https://tukaani.org/xz/java.html"
SRC_URI="https://tukaani.org/xz/${P}.zip
	verify-sig? ( https://tukaani.org/xz/${P}.zip.sig )"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-lassecollin )
"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/lassecollin.asc"

JAVA_SRC_DIR="src/org"

DOCS=( README NEWS COPYING THANKS )

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples src/*Demo.java
	einstalldocs
}
