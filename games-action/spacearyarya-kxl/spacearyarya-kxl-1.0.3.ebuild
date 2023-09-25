# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="2D/3D shooting game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="
	https://gitlab.com/oss-abandonware/games-action/space-aryarya/-/archive/${PV}/space-aryarya-${PV}.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/space-aryarya-${PV}"

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

src_prepare() {
	default

	sed -i "s|DATA_PATH \"/.score\"|\"${EPREFIX}/var/games/${PN}.hs\"|" src/ranking.c || die

	eautoreconf
}

src_install() {
	emake -C data DESTDIR="${D}" install-dataDATA
	default

	rm "${ED}"/usr/share/SpaceAryarya/data/.score
	insinto /var/games
	newins data/.score ${PN}.hs

	fowners :gamestat /var/games/${PN}.hs /usr/bin/spacearyarya
	fperms g+s /usr/bin/spacearyarya
	fperms 660 /var/games/${PN}.hs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry spacearyarya SpaceAryarya
}
