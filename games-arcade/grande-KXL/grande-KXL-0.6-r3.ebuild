# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="ZANAC type game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	acct-group/gamestat
	dev-games/KXL"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi
	media-fonts/font-bitstream-100dpi"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-paths.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --with-highscore-path="${EPREFIX}/var/games"
}

src_install() {
	dodir /var/games
	default

	fowners :gamestat /var/games/grande.scores /usr/bin/grande
	fperms g+s /usr/bin/grande
	fperms 660 /var/games/grande.scores

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry grande Grande
}
