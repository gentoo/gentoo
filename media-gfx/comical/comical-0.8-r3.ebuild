# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/comical/comical-0.8-r3.ebuild,v 1.4 2012/06/18 18:38:28 ago Exp $

EAPI=4
inherit eutils gnome2-utils toolchain-funcs wxwidgets

DESCRIPTION="A sequential image display program, to deal with .cbr and .cbz files"
HOMEPAGE="http://comical.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-arch/unrar-4.1.4-r2
	sys-libs/zlib[minizip]
	x11-libs/wxGTK:2.8[X]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	export WX_GTK_VER=2.8
	need-wxwidgets unicode

	epatch \
		"${FILESDIR}"/${P}-wxGTK-2.8.patch \
		"${FILESDIR}"/${P}-syslibs.patch

	sed -i -e "s:wx-config:${WX_CONFIG}:" {.,src}/Makefile || die

	rm -rf un{rar,zip}
}

src_compile() {
	tc-export CXX
	emake -j1
}

src_install() {
	dobin ${PN}
	dodoc AUTHORS ChangeLog README TODO

	doicon 'Comical Icons'/${PN}.xpm
	doicon -s 128 'Comical Icons'/${PN}.png

	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
