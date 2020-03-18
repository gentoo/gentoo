# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/wm/WM}

DESCRIPTION="A Window Maker dock app client for Music Player Daemon(media-sound/mpd)"
HOMEPAGE="http://mpd.wikia.com/wiki/Client:WMmp"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf --with-default-port=6600
}
