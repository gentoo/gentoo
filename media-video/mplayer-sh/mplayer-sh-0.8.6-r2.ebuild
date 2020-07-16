# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

RESTRICT="mirror bindist"

inherit eutils

DESCRIPTION="Video Disk Recorder Mplayer API Script"
HOMEPAGE="http://batleth.sapienti-sat.org/"
SRC_URI="http://batleth.sapienti-sat.org/projects/VDR/mplayer.sh-${PV}.tar.gz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="all-rights-reserved"
IUSE=""

RDEPEND=">=media-video/mplayer-0.90_rc4"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/${P}-parameter-aid.diff"

	sed -i "s:^declare CFGFIL.*$:declare CFGFIL=\"\/etc\/vdr\/plugins\/mplayer\/mplayer.sh.conf\":"  mplayer.sh
	sed -i mplayer.sh.conf -e "s:^LIRCRC.*$:LIRCRC=\/etc\/lircd.conf:" \
		-e "s:^MPLAYER=.*$:MPLAYER=\/usr\/bin\/mplayer:"
}

src_install() {

	insinto /etc/vdr/plugins/mplayer
	doins mplayer.sh.conf

	into /usr/share/vdr/mplayer
	dobin mplayer.sh

	dodir /etc/vdr/plugins/DVD-VCD
	touch "${D}"/etc/vdr/plugins/DVD-VCD/{DVD,VCD}
	fowners vdr:video /etc/vdr/plugins/DVD-VCD/{DVD,VCD}
}
