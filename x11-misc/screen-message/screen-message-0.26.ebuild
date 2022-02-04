# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit xdg

DESCRIPTION="Display a multi-line message large, fullscreen, black on white"
HOMEPAGE="http://www.joachim-breitner.de/projects#screen-message"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:3
	x11-libs/cairo
	>=x11-libs/pango-1.16"
RDEPEND="${DEPEND}"

src_install() {
	default

	# It's not a game so let's make it *not* end up /usr/games
	dodir /usr/bin
	mv "${D}"/usr/{games,bin}/sm || die
	rmdir "${D}"/usr/games || die
	sed 's|^Exec=/usr/games/sm|Exec=/usr/bin/sm|' \
		-i "${D}"/usr/share/applications/sm.desktop || die
}
