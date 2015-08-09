# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="MPlayer wrapper script to save/resume playback position"
HOMEPAGE="http://www.spaceparanoids.org/trac/bend/wiki/mplayer-resume"
SRC_URI="http://spaceparanoids.org/downloads/mplayer-resume/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+lirc"
DEPEND=""
RDEPEND="lirc? ( app-misc/lirc
		media-video/mplayer[lirc] )
		 dev-lang/php[cli]
		 || ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )
	media-video/mplayer"

src_compile() {
	return;
}

src_install() {
	dobin mplayer-resume
	dodoc ChangeLog README
}

pkg_postinst() {
	elog "To get mplayer-resume to save playback position with LIRC,"
	elog "you will need to setup an entry in ~/.lircrc to run "
	elog "'get_time_pos' and then 'quit'.  More instructions are"
	elog "detailed in the README, but the position will not be saved"
	elog "until you set it up."
	elog ""
	elog "Playback position files are saved in ~/.mplayer/playback"
}
