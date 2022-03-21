# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

MY_PN="sax2r3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SAX: Simple API for XML in Java"
HOMEPAGE="http://sax.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}.zip -> ${P}.zip"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	>=virtual/jdk-1.8:*"

RDEPEND="
	>=virtual/jre-1.8:*"

BDEPEND="
	app-arch/unzip
	source? ( app-arch/zip )"

JAVADOC_ARGS="-source 8"

S="${WORKDIR}/sax2r3"

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	dodoc ChangeLog CHANGES README
}
