# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="http://shinh.skr.jp/libbulletml/index_en.html"
SRC_URI="http://shinh.skr.jp/libbulletml/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/boost"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN#lib}/src

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc46.patch
	rm -r boost || die
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dolib.a libbulletml.a

	insinto /usr/include/bulletml
	doins *.h

	insinto /usr/include/bulletml/tinyxml
	doins tinyxml/tinyxml.h

	insinto /usr/include/bulletml/ygg
	doins ygg/ygg.h

	dodoc ../README*
}
