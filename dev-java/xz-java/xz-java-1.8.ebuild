# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of xz data compression in pure java"
HOMEPAGE="https://tukaani.org/xz/java.html"
SRC_URI="https://tukaani.org/xz/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

S="${WORKDIR}"

JAVA_SRC_DIR="src/org"

DOCS=( README NEWS COPYING THANKS )

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples src/*Demo.java
	einstalldocs
}
