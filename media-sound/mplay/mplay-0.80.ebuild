# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Curses front-end for mplayer"
HOMEPAGE="http://mplay.sourceforge.net"
SRC_URI="mirror://sourceforge/mplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="dev-lang/perl
	>=dev-perl/MP3-Info-1.11
	dev-perl/Audio-Mixer
	dev-perl/Ogg-Vorbis-Header-PurePerl
	>=virtual/perl-Time-HiRes-1.56
	>=dev-perl/TermReadKey-2.21
	dev-perl/Video-Info
	media-video/mplayer"

src_prepare() {
	default
	sed -i 's:/usr/local:/usr:g' mplay || die "Unable fix the /usr/local path issues"
}

src_install() {
	dobin mplay
	einstalldocs

	cd help || die
	insinto /usr/share/mplay
	doins help_en help_de mplayconf
	doman mplay.1
}

pkg_postinst() {
	elog "Please note, gnome terminal does not like this program"
	elog "too much.  xterm,kterm, and konsole can use it ok."
}
