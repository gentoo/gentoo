# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A Curses front-end for mplayer"
HOMEPAGE="http://mplay.sourceforge.net"
SRC_URI="mirror://sourceforge/mplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=dev-perl/MP3-Info-1.11
	dev-perl/Audio-Mixer
	dev-perl/Ogg-Vorbis-Header-PurePerl
	>=virtual/perl-Time-HiRes-1.56
	>=dev-perl/TermReadKey-2.21
	dev-perl/Video-Info
	media-video/mplayer"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's:/usr/local:/usr:g' mplay || die "Unable fix the /usr/local path issues."
}

src_install() {
	dobin mplay || die
	dodoc README || die

	cd "${S}"/help
	insinto /usr/share/mplay
	doins help_en help_de mplayconf || die
	doman mplay.1
}

pkg_postinst() {
	elog "Please note, gnome terminal does not like this program"
	elog "too much.  xterm,kterm, and konsole can use it ok."
}
