# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A graphical network monitor for Unix modeled after etherman"
HOMEPAGE="https://etherape.sourceforge.io/"
SRC_URI="mirror://sourceforge/etherape/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/popt
	net-libs/libpcap
	x11-libs/goocanvas:2.0
"
DEPEND="
	${RDEPEND}
	>=sys-devel/gettext-0.11.5
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	virtual/pkgconfig
"
