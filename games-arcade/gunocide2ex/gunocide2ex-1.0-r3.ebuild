# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop edos2unix toolchain-funcs unpacker

DESCRIPTION="Fast-paced 2D shoot'em'up"
HOMEPAGE="https://sourceforge.net/projects/g2ex/"
SRC_URI="mirror://sourceforge/g2ex/g2ex-setup.run"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-glibc2.10.patch
)

src_unpack() {
	unpack_makeself
	mkdir binary || die
}

src_prepare() {
	default

	edos2unix config.cfg

	sed -i \
		-e "s:/usr/local/games/gunocide2ex/config\.cfg:/etc/${PN}.cfg:" \
		-e "s:/usr/local/games/gunocide2ex/hscore\.dat:/var/games/gunocide2ex/${PN}-hscore.dat:" \
		-e "s:memleaks.log:/dev/null:" \
		src/*.{h,cpp} || die

	sed -i \
		-e "s:/usr/local/games:/usr/share:" \
		src/*.{h,cpp} $(find gfx -name '*.txt') || die
}

src_compile() {
	cd src || die

	tc-export CXX

	emake \
		CXXFLAGS="${CXXFLAGS} $(sdl-config --cflags)" \
		$(echo *.cpp | sed 's/\.cpp/.o/g')

	$(tc-getCXX) ${CPPFLAGS} ${CXXFLAGS} ${LDFLAGS} -o ${PN} *.o -lpthread -lSDL -lSDL_ttf -lSDL_mixer || die
}

src_install() {
	dobin src/${PN}
	dosym ${PN} /usr/bin/g2ex

	insinto /usr/share/${PN}
	doins -r gfx sfx lvl credits arial.ttf

	insinto /etc
	newins config.cfg ${PN}.cfg

	insinto /var/games/${PN}
	newins hscore.dat ${PN}-hscore.dat

	fperms 660 /var/games/${PN}/${PN}-hscore.dat
	fowners -R root:gamestat /var/games/${PN} /usr/bin/g2ex
	fperms g+s /usr/bin/g2ex

	dodoc history doc/MANUAL_DE
	docinto html
	dodoc doc/manual_de.html

	newicon g2icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Gunocide II EX"
}
