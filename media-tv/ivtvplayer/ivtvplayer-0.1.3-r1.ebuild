# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="Simple IVTV command line TV and radio player with support of LIRC"
HOMEPAGE="http://sourceforge.net/projects/ivtvplayer/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="gtk xosd"
RDEPEND="|| ( media-tv/ivtv media-tv/v4l-utils )
	 || ( media-video/mplayer[v4l]
	 	media-video/mplayer[dvb] )
	 media-sound/alsa-utils
	 dev-perl/XML-Simple
	 gtk? ( dev-perl/gtk2-perl )
	 xosd? ( dev-perl/X-Osd )
	 >=dev-perl/Lirc-Client-1.50"
DEPEND=""

src_install() {
	dobin bin/itv
	dobin bin/iradio
	if use gtk ; then
		dobin bin/ictl
	fi
	dodoc doc/README doc/CHANGES
	dodoc conf/*
}

pkg_postinst() {
	einfo ""
	einfo "Example of itv, iradio and its LIRC configuration file is located in"
	einfo "directory /usr/share/doc/${PF}/."
	einfo ""
}
