# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="mplay-${PV}"

DESCRIPTION="mplayer wrapper script as backend for vdr-mplayer"
HOMEPAGE="http://www.vdr-portal.de/board/thread.php?threadid=62306"
SRC_URI="mirror://gentoo/${MY_P}.tgz
	https://dev.gentoo.org/~zzam/distfiles/${MY_P}.tgz"

KEYWORDS="x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-tv/gentoo-vdr-scripts"
RDEPEND=">=media-video/mplayer-0.90_rc4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i mplay.sh \
		-e 's#$CONFDIR/silence.wav#/usr/share/vdr/mplay-sh/silence.wav#'
	sed -i conf.examples/mplayrc \
		-e 's#^MPLAY_PLAY.*#MPLAY_PLAY="/var/vdr/tmp/mplay.play"#'
}

src_install() {
	exeinto /usr/share/vdr/mplayer/bin
	doexe mplay.sh

	insinto /etc/vdr/plugins/mplay
	doins conf.examples/*.conf conf.examples/mplayrc

	insinto /usr/share/vdr/mplay-sh
	doins conf.examples/silence.wav

	dodoc README* HISTORY
	keepdir /var/vdr/tmp
	chown vdr:vdr -R "${D}/var/vdr"
}
