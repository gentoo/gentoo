# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

MY_P="twind-${PV}"

DESCRIPTION="Match and remove all of the blocks before time runs out"
HOMEPAGE="http://twind.sourceforge.net/"
SRC_URI="mirror://sourceforge/twind/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-warnings.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin twind

	insinto /usr/share/twindistress
	doins -r graphics music sound

	doicon graphics/twind.png
	make_desktop_entry twind "Twin Distress"

	einstalldocs

	dodir /var/lib/twindistress/
	touch "${ED}"/var/lib/twindistress/twind.hscr || die
	fowners root:users /var/lib/twindistress/twind.hscr
	fperms 660 /var/lib/twindistress/twind.hscr
}
