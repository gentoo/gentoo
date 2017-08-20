# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2-utils

DESCRIPTION="Japanese Canna input method module for GTK+2"
HOMEPAGE="http://bonobo.gnome.gr.jp/~nakai/immodule/"
SRC_URI="http://bonobo.gnome.gr.jp/~nakai/immodule/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="app-i18n/canna
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

pkg_postinst() {
	gnome2_query_immodules_gtk2
}

pkg_postrm() {
	gnome2_query_immodules_gtk2
}
