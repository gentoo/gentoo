# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Gothic science fantasy roguelike game"
HOMEPAGE="https://freecode.com/projects/wrogue"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/libsdl[video]"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	sed -i \
		-e "/AppData\[0\]/ s:AppData.*:strcpy(AppData, \"${GAMES_DATADIR}/${PN}/\");:" \
		src/lib/appdir.c \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	local myCPPFLAGS="-std=c99 -Iinclude -Ilib -Iui -Igenerate"
	local myCFLAGS="$(sdl-config --cflags) ${CFLAGS}"
	emake -C src -f linux.mak STRIP_BINARY=NO \
		CFLAGS="${myCPPFLAGS} ${myCFLAGS}" release
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data
	dodoc changes.txt

	newicon data/ui/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Warp Rogue" /usr/share/pixmaps/${PN}.bmp

	prepgamesdirs
}
