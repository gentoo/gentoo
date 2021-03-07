# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: show background image for radio and decode RDS Text"
HOMEPAGE="http://www.vdr-portal.de/board/thread.php?threadid=58795"
SRC_URI="http://www.egal-vdr.de/plugins/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-video/vdr"
DEPEND="${RDEPEND}"

VDR_RCADDON_FILE="${FILESDIR}/rc-addon.sh"

src_install() {
	vdr-plugin-2_src_install

	cd "${S}"/config || die "Can't enter source folder"

	insinto /usr/share/vdr/radio
	doins mpegstill/rtext*
	dosym rtextOben-kleo2-live.mpg /usr/share/vdr/radio/radio.mpg
	dosym rtextOben-kleo2-replay.mpg /usr/share/vdr/radio/replay.mpg

	exeinto /usr/share/vdr/radio
	doexe scripts/radioinfo*
}
