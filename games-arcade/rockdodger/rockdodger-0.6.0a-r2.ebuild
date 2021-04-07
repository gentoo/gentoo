# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Dodge the rocks for as long as possible until you die"
HOMEPAGE="http://spacerocks.sourceforge.net/"
SRC_URI="mirror://sourceforge/spacerocks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}"/${PV}-sec.patch
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare() {
	default

	# Modify highscores & data directory and add our CFLAGS to the Makefile
	sed -i \
		-e "s:\./data:/var/games/${PN}:" \
		-e "s:/usr/share/rockdodger/\.highscore:/var/games/${PN}/rockdodger.scores:" \
		-e 's:umask(0111):umask(0117):' \
		main.c || die " sed main.c failed"

	sed -i \
		-e "s:-g:${CFLAGS}:" \
		-e 's:cc:${CC}:' \
		-e '/-o/s:\$+:$(LDFLAGS) $+:' \
		Makefile || die "sed Makefile failed"

	# The 512 chunksize makes the music skip
	sed -i -e "s:512:1024:" sound.c || die "sed sound.c failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins data/*

	newicon spacerocks.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Rock Dodger" ${PN}

	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/${PN}.scores || die

	fperms 660 /var/games/${PN}/${PN}.scores
	fowners -R root:gamestat /var/games/${PN}
	fperms g+s /usr/bin/${PN}
}
