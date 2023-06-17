# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	# Fix error: AM_INIT_AUTOMAKE expanded multiple times
	sed -i -e '/^AM_INIT_AUTOMAKE$/d' configure.ac || die

	# Fix the name of the icon
	sed -i -e 's/Icon=spotify/Icon=spotify-client/g' spotify-tray.desktop.in || die
	eautoreconf
}

src_install() {
	default
	# remove desktop file, launching is handled in spotify ebuild
	rm "${ED}/usr/share/applications/spotify-tray.desktop" || die

	# move executable outside of PATH to avoid accidentally launching it in a loop
	mkdir -p "${ED}/opt/spotify/spotify-client" || die
	mv "${ED}/usr/bin/spotify-tray" "${ED}/opt/spotify/spotify-client/spotify-tray" || die
}
