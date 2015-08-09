# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="VDR script: generate shoutcast playlists"
HOMEPAGE="http://www.vdr-portal.de/board/thread.php?threadid=19478"
SRC_URI="http://www.kost.sh/vdr/${P}.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-video/vdr"
RDEPEND=""

S="${WORKDIR}"

PLAYLIST_DIR="/var/cache/vdr/music/playlists"

src_prepare() {
	sed -i shoutcast2vdr-0.0.8 -e "s:outputdir=/home/volker/vdr/radio:outputdir=${PLAYLIST_DIR}:"

	# wrt bug 520624
	sed -i shoutcast2vdr-0.0.8 -e "s:mkdir:mkdir -p:"
}

src_install() {
	exeinto /usr/share/vdr/shoutcast2vdr
	newexe shoutcast2vdr-0.0.8 shoutcast2vdr
}
