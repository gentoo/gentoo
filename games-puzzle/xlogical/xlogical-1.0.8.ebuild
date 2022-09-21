# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

MY_P="${PN}-$(ver_rs 2 -)"

DESCRIPTION="Puzzle game based on the Logical! game released on the Commodore Amiga"
HOMEPAGE="https://changeling.ixionstudios.com/xlogical/"
SRC_URI="
	https://changeling.ixionstudios.com/xlogical/downloads/${MY_P}.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[mod]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc4.3.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	default

	sed -e "/^CXXFLAGS/d" \
		-e "s|@localstatedir@/xlogical|${EPREFIX}/var/games|" \
		-i Makefile.am || die

	eautoreconf
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r ${PN}.{properties,levels} images music sound
	find "${ED}" -name "Makefile*" -delete || die

	insinto /var/games
	doins ${PN}.scores

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.scores
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.scores

	einstalldocs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "XLogical"
}
