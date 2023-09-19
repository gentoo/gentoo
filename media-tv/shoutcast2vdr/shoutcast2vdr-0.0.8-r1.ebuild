# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="VDR script: generate shoutcast playlists"
HOMEPAGE="http://www.vdr-portal.de/board/thread.php?threadid=19478"
SRC_URI="http://www.kost.sh/vdr/${P}.gz"
S="${WORKDIR}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="media-video/vdr"

PLAYLIST_DIR="/var/cache/vdr/music/playlists"

src_prepare() {
	default
	sed -i shoutcast2vdr-0.0.8 -e "s:outputdir=/home/volker/vdr/radio:outputdir=${PLAYLIST_DIR}:" || die

	# wrt bug 520624
	sed -i shoutcast2vdr-0.0.8 -e "s:mkdir:mkdir -p:" || die
}

src_install() {
	exeinto /usr/share/vdr/shoutcast2vdr
	newexe shoutcast2vdr-0.0.8 shoutcast2vdr
}
