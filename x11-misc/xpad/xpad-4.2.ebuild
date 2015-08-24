# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="a sticky note application for jotting down things to remember"
HOMEPAGE="http://mterry.name/xpad"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-2.12:2
	>=dev-libs/glib-2.38:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	>=dev-util/intltool-0.31
	virtual/pkgconfig
	sys-devel/gettext
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )
