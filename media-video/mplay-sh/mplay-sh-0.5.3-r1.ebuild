# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="mplay-${PV}"

DESCRIPTION="mplayer wrapper script as backend for vdr-mplayer"
HOMEPAGE="https://www.vdr-portal.de/board/thread.php?threadid=62306"
SRC_URI="mirror://gentoo/${MY_P}.tgz
	https://dev.gentoo.org/~zzam/distfiles/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

# for vdr user?
DEPEND="media-tv/gentoo-vdr-scripts"
RDEPEND="${DEPEND}
	>=media-video/mplayer-0.90_rc4"

src_prepare() {
	default

	sed -i mplay.sh \
		-e 's#$CONFDIR/silence.wav#/usr/share/vdr/mplay-sh/silence.wav#' || die
	sed -i conf.examples/mplayrc \
		-e 's#^MPLAY_PLAY.*#MPLAY_PLAY="/var/vdr/tmp/mplay.play"#' || die
}

src_install() {
	exeinto /usr/share/vdr/mplayer/bin
	doexe mplay.sh

	insinto /etc/vdr/plugins/mplay
	doins conf.examples/*.conf conf.examples/mplayrc

	insinto /usr/share/vdr/mplay-sh
	doins conf.examples/silence.wav

	dodoc HISTORY README*

	keepdir /var/vdr/tmp
	fowners -R vdr:vdr /var/vdr
}
