# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="WindowMaker/AfterStep system monitor dockapp"
HOMEPAGE="http://rio.vg/asmon"
SRC_URI="http://rio.vg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die

	cd "${WORKDIR}"/${P} || die
	epatch "${FILESDIR}"/${P}-list.patch
}

src_compile() {
	emake clean
	emake SOLARIS="${CFLAGS}" LIBDIR="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ../Changelog
}
