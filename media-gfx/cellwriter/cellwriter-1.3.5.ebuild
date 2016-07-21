# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnome2-utils

DESCRIPTION="Grid-entry natural handwriting input panel"
HOMEPAGE="http://risujin.org/cellwriter/"
SRC_URI="http://pub.risujin.org/cellwriter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog README TODO" # NEWS is no-op

src_prepare() {
	sed -i -e '/Encoding/d' ${PN}.desktop || die
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
