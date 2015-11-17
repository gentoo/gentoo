# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit versionator

XPAD_MAJOR_MINOR=$(get_version_component_range 1-2)

DESCRIPTION="a sticky note application for jotting down things to remember"
HOMEPAGE="http://mterry.name/xpad"
SRC_URI="https://launchpad.net/${PN}/trunk/${XPAD_MAJOR_MINOR}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.40:2
	app-accessibility/at-spi2-atk
	dev-libs/atk
	sys-devel/gettext
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	>=dev-util/intltool-0.31
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )
