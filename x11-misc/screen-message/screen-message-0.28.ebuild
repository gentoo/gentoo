# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools xdg

DESCRIPTION="Display a multi-line message large, fullscreen, black on white"
HOMEPAGE="http://www.joachim-breitner.de/projects#screen-message
	https://github.com/nomeata/screen-message"
SRC_URI="https://github.com/nomeata/screen-message/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/gtk+:3
	x11-libs/cairo
	>=x11-libs/pango-1.16"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_install() {
	default

	# It's not a game so let's make it *not* end up in /usr/games
	dodir /usr/bin
	mv "${D}"/usr/{games,bin}/sm || die
	rmdir "${D}"/usr/games || die
	sed 's|^Exec=/usr/games/sm|Exec=/usr/bin/sm|' \
		-i "${D}"/usr/share/applications/sm.desktop || die
}
