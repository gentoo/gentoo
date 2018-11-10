# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eapi7-ver gnome2-utils

MATE_GTK_V="$(ver_cut 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/themes/${MATE_GTK_V}/${P}.tar.xz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

HOMEPAGE="http://mate-desktop.org"
DESCRIPTION="A set of MATE themes, with sets for users with limited or low vision"
LICENSE="LGPL-2.1 GPL-3"
SLOT="0/${MATE_GTK_V}"

COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2:2
	>=x11-libs/gtk+-2:2
	>=x11-themes/gtk-engines-2.15.3:2
	x11-themes/gtk-engines-murrine
"
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35:*
	sys-devel/gettext:*
	>=sys-devel/autoconf-2.53:*
	>=x11-misc/icon-naming-utils-0.8.7:0
	virtual/pkgconfig:*
"

RESTRICT="binchecks strip"

src_prepare() {
	default
	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
