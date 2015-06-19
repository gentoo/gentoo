# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gst123/gst123-0.3.2.ebuild,v 1.1 2013/01/12 21:32:55 radhermit Exp $

EAPI=5

DESCRIPTION="A more flexible command line player in the spirit of ogg123 and mpg123, based on gstreamer"
HOMEPAGE="http://space.twc.de/~stefan/gst123.php"
SRC_URI="http://space.twc.de/~stefan/gst123/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-libs/glib
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	sys-libs/ncurses
	x11-libs/gtk+:2
	x11-libs/libX11"
RDEPEND="${CDEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
