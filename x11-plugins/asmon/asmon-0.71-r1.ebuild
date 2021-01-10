# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WindowMaker/AfterStep system monitor dockapp"
HOMEPAGE="http://rio.vg/asmon"
SRC_URI="http://rio.vg/${PN}/${P}.tar.bz2"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"

RDEPEND="x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default

	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die

	cd "../wmgeneral" || die
	eapply "${FILESDIR}/${P}-list.patch"
	eapply "${FILESDIR}/${P}-fno-common.patch"
}

src_compile() {
	emake clean
	emake SOLARIS="${CFLAGS}" LIBDIR="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ../Changelog
}
