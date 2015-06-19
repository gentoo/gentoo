# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/purple-libnotify-plus/purple-libnotify-plus-1.99.2.ebuild,v 1.3 2012/12/04 15:41:21 ago Exp $

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
