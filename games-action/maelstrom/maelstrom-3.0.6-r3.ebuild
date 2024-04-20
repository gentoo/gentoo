# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="An asteroids battle game"
HOMEPAGE="http://www.libsdl.org/projects/Maelstrom/"
SRC_URI="http://www.libsdl.org/projects/Maelstrom/src/${P^}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-net"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}"/${P}-security.patch
	"${FILESDIR}"/${P}-64bits.patch
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-warnings.patch
	"${FILESDIR}"/${P}-gcc53.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default

	# Install the high scores file in ${GAMES_STATEDIR}
	sed -i \
		-e "s:path.Path(MAELSTROM_SCORES):\"/var/games/\"MAELSTROM_SCORES:" scores.cpp || die
	mv configure.{in,ac} || die
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
