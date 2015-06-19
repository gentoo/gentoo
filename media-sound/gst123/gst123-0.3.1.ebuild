# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gst123/gst123-0.3.1.ebuild,v 1.2 2012/05/05 08:27:50 mgorny Exp $

EAPI=4

DESCRIPTION="A more flexible command line player in the spirit of ogg123 and mpg123, based on gstreamer"
HOMEPAGE="http://space.twc.de/~stefan/gst123.php"
SRC_URI="http://space.twc.de/~stefan/gst123/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-libs/glib
	media-libs/gst-plugins-base:0.10
	media-libs/gstreamer:0.10
	sys-libs/ncurses
	x11-libs/gtk+:2
	x11-libs/libX11"
RDEPEND="${CDEPEND}
	media-plugins/gst-plugins-meta:0.10"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
