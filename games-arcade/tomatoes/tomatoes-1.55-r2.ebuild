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
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-c_str.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

src_prepare() {
	mv ../tomatoes-1.5/* . || die "mv failed"
	mv icon.png ${PN}.png

	default

	sed -i \
		-e "/^MPKDIR = /s:./:/usr/share/${PN}/:" \
		-e "/^MUSICDIR = /s:./music/:/usr/share/${PN}/music/:" \
		-e "/^HISCOREDIR = /s:./:/var/lib/${PN}/:" \
		-e "/^CONFIGDIR = /s:./:$/etc/${PN}/:" \
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

	dodir /var/lib/${PN}
	touch "${ED}"/var/lib/${PN}/hiscore.lst || die "touch failed"
	fperms 660 /var/lib/${PN}/hiscore.lst

	insinto /etc/${PN}
	doins config.cfg
}
