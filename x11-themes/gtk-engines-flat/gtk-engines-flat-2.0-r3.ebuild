# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools gnome2

MY_P=gtk-flat-theme-${PV}

DESCRIPTION="GTK+ Flat Theme Engine"
HOMEPAGE="https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/x11-themes/gtk-engines-flat/"
SRC_URI="http://download.freshmeat.net/themes/gtk2flat/gtk2flat-default.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	eautoreconf # need new libtool for interix
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	rm -f "${ED}"/usr/share/themes/Flat/{ICON.png,README.html}
}
