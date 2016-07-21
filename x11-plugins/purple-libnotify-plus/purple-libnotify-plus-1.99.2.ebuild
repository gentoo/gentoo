# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Provide libnotify interface to Pidgin and Finch, inspired by Pidgin-libnotify and Guifications"
HOMEPAGE="http://purple-libnotify-plus.sardemff7.net/"
SRC_URI="mirror://github/sardemff7/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	net-im/pidgin
	net-im/purple-events
	x11-libs/gdk-pixbuf
	x11-libs/libnotify"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf --disable-silent-rules
}
