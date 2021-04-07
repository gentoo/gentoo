# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DATA_PV=1.5
DESCRIPTION="How many tomatoes can you smash in ten short minutes?"
HOMEPAGE="http://tomatoes.sourceforge.net/about.html"
SRC_URI="mirror://sourceforge/tomatoes/tomatoes-linux-src-${PV}.tar.bz2
	mirror://sourceforge/tomatoes/tomatoes-linux-${DATA_PV}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	virtual/opengl
	virtual/glu
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}"/${P}-c_str.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

src_prepare() {
	default

	mv ../tomatoes-1.5/* . || die "mv failed"
	mv icon.png ${PN}.png || die

	sed -i \
		-e "/^MPKDIR = /s:./:/usr/share/${PN}/:" \
		-e "/^MUSICDIR = /s:./music/:/usr/share/${PN}/music/:" \
		-e "/^HISCOREDIR = /s:./:/var/games/${PN}/:" \
		-e "/^CONFIGDIR = /s:./:/etc/${PN}/:" \
		-e "/^OVERRIDEDIR = /s:./data/:/usr/share/${PN}/data/:" \
		makefile \
		|| die "sed failed"
}

src_configure() {
	tc-export CXX
}

src_install() {
	dobin tomatoes
	dodoc README README-src

	insinto /usr/share/${PN}
	doins -r tomatoes.mpk music

	doicon ${PN}.png
	make_desktop_entry tomatoes "I Have No Tomatoes"

	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/hiscore.lst || die "touch failed"

	fperms 660 /var/games/${PN}/hiscore.lst
	fowners -R root:gamestat /var/games/${PN}
	fperms g+s /usr/bin/${PN}

	insinto /etc/${PN}
	doins config.cfg
}
