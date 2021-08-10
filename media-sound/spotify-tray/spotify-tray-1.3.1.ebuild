# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Wrapper around the Spotify client that adds a tray icon"
HOMEPAGE="https://github.com/tsmetana/spotify-tray"
SRC_URI="https://github.com/tsmetana/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	x11-libs/gtk+:3[X]
"
RDEPEND="${DEPEND}
	media-sound/spotify
"

src_prepare() {
	default
	# Fix the name of the icon
	sed -i -e 's/Icon=spotify/Icon=spotify-client/g' spotify-tray.desktop.in || die
	eautoreconf
}
