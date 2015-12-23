# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic

DESCRIPTION="GTK-based collaborative editor"
HOMEPAGE="http://gobby.0x539.de/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnome zeroconf"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/libsigc++:2
	>=net-libs/obby-0.4.6[zeroconf?]
	dev-cpp/libxmlpp:2.6
	x11-libs/gtksourceview:2.0
	gnome? ( gnome-base/gnome-vfs )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

# There's only one test and it needs X
RESTRICT="test"

src_configure() {
	append-cxxflags -std=c++11
	econf \
		--with-gtksourceview2 \
		$(use_with gnome)
}

src_install() {
	default
	domenu contrib/gobby.desktop
}
