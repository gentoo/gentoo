# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="GTK+ based algebraic and RPN calculator"
HOMEPAGE="http://galculator.mnim.org/"
SRC_URI="http://galculator.mnim.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/pango
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS="AUTHORS ChangeLog NEWS README THANKS doc/shortcuts"
