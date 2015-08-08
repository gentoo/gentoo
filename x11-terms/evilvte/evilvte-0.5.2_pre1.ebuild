# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit gnome2-utils toolchain-funcs savedconfig

MY_P=${P/_/\~}

DESCRIPTION="VTE based, super lightweight terminal emulator"
HOMEPAGE="http://www.calno.com/evilvte"
SRC_URI="http://www.calno.com/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:3
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=ChangeLog

src_prepare() {
	restore_config src/config.h
}

src_configure() {
	tc-export CC
	./configure --prefix=/usr --with-gtk=3.0 || die
}

src_compile() {
	emake -j1
}

src_install() {
	default
	save_config src/config.h
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	savedconfig_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
