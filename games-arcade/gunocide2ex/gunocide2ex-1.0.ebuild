# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils unpacker toolchain-funcs games

DESCRIPTION="fast-paced 2D shoot'em'up"
HOMEPAGE="http://g2ex.sourceforge.net/"
SRC_URI="mirror://sourceforge/g2ex/g2ex-setup.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_unpack() {
	unpack_makeself
	mkdir binary || die
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-glibc2.10.patch
	edos2unix config.cfg
	sed -i \
		-e "s:/usr/local/games/gunocide2ex/config\.cfg:${GAMES_SYSCONFDIR}/${PN}.cfg:" \
		-e "s:/usr/local/games/gunocide2ex/hscore\.dat:${GAMES_STATEDIR}/${PN}-hscore.dat:" \
		-e "s:memleaks.log:/dev/null:" \
		src/*.{h,cpp} || die
	sed -i \
		-e "s:/usr/local/games:${GAMES_DATADIR}:" \
		src/*.{h,cpp} $(find gfx -name '*.txt') || die
}

src_compile() {
	cd src
	emake CXXFLAGS="$CXXFLAGS $(sdl-config --cflags)" $(echo *.cpp | sed 's/\.cpp/.o/g')
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o ${PN} *.o -lpthread -lSDL -lSDL_ttf -lSDL_mixer || die
}

src_install() {
	dogamesbin src/${PN}
	dosym ${PN} "${GAMES_BINDIR}/g2ex"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r gfx sfx lvl credits arial.ttf
	insinto "${GAMES_SYSCONFDIR}"
	newins config.cfg ${PN}.cfg
	insinto "${GAMES_STATEDIR}"
	newins hscore.dat ${PN}-hscore.dat
	dodoc history doc/MANUAL_DE
	dohtml doc/manual_de.html
	newicon g2icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Gunocide II EX"
	prepgamesdirs
}
