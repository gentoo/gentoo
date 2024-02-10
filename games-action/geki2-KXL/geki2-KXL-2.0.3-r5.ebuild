# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="2D length scroll shooting game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	acct-group/gamestat
	dev-games/KXL"
RDEPEND="
	${DEPEND}
	media-fonts/font-adobe-100dpi
	media-fonts/font-bitstream-100dpi"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	sed -i "s|DATA_PATH \"/.score\"|\"${EPREFIX}/var/games/${PN}.hs\"|" src/ranking.c || die

	eautoreconf
}

src_install() {
	emake -C data DESTDIR="${D}" install-dataDATA
	default

	rm "${ED}"/usr/share/geki2/data/.score
	insinto /var/games
	newins data/.score ${PN}.hs

	fowners :gamestat /var/games/${PN}.hs /usr/bin/geki2
	fperms g+s /usr/bin/geki2
	fperms 660 /var/games/${PN}.hs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry geki2 Geki2
}
