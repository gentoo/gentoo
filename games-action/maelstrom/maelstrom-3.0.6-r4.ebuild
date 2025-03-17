# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="An asteroids battle game"
HOMEPAGE="https://www.libsdl.org/projects/Maelstrom/"
SRC_URI="https://www.libsdl.org/projects/Maelstrom/src/${P^}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-net"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-security.patch
	"${FILESDIR}"/${P}-64bits.patch
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-warnings.patch
	"${FILESDIR}"/${P}-gcc53.patch
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-fix_return_type.patch
	"${FILESDIR}"/${P}-clang-sprintf.patch
)

src_prepare() {
	default

	rm aclocal.m4 acinclude.m4 || die
	eautoreconf
}

src_install() {
	default
	dodoc Changelog Docs/{Maelstrom-Announce,*FAQ,MaelstromGPL_press_release,*.Paper,Technical_Notes*}

	newicon "${ED}"/usr/share/Maelstrom/icon.xpm maelstrom.xpm
	make_desktop_entry Maelstrom "Maelstrom" maelstrom

	# Put the high scores file in the right place
	insinto /var/games
	doins "${ED}"/usr/share/Maelstrom/Maelstrom-Scores

	# clean up some cruft
	rm \
		"${ED}"/usr/share/Maelstrom/Maelstrom-Scores \
		"${ED}"/usr/share/Maelstrom/Images/Makefile* || die

	# make sure we can update the high scores
	fowners root:gamestat /var/games/Maelstrom-Scores /usr/bin/Maelstrom{,-netd}
	fperms 2755 /usr/bin/Maelstrom{,-netd}
	fperms 660 /var/games/Maelstrom-Scores
}
