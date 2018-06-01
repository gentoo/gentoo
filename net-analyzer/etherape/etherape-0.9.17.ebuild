# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="A graphical network monitor for Unix modeled after etherman"
HOMEPAGE="http://etherape.sourceforge.net/"
SRC_URI="mirror://sourceforge/etherape/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=gnome-base/libglade-2.0
	gnome-base/libgnomecanvas[glade]
	net-libs/libpcap
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.11.5
	app-text/docbook-xml-dtd:4.1.2
	app-text/gnome-doc-utils
	virtual/pkgconfig
"
