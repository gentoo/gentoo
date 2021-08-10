# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

MY_PN=${PN/emilia-/}
MY_P=${MY_PN}-${PV}
DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="http://pinball.sourceforge.net/"
SRC_URI="mirror://sourceforge/pinball/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libltdl:0
	media-libs/libsdl[joystick,opengl,video,X]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	x11-libs/libICE
	x11-libs/libSM
	virtual/opengl
	virtual/glu
"
DEPEND="
	${DEPEND}
	x11-libs/libXt
"

RDEPEND+=" acct-group/gamestat"

PATCHES=(
	"${FILESDIR}"/${P}-glibc210.patch
	"${FILESDIR}"/${P}-libtool.patch
	"${FILESDIR}"/${P}-gcc46.patch
	"${FILESDIR}"/${P}-parallel.patch
)

src_prepare() {
	# bug #334899
	sed -i -e '/dnl/d' {src,test}/Makefile.am || die

	default

	rm -rf libltdl || die
	eautoreconf
}

src_configure() {
	econf --with-x
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	default

	dosym pinball /usr/bin/emilia-pinball

	sed -i \
		-e 's:-I${prefix}/include/pinball:-I/usr/include/pinball:' \
		"${ED}"/usr/bin/pinball-config || die

	newicon data/pinball.xpm ${PN}.xpm
	make_desktop_entry emilia-pinball "Emilia pinball"

	fperms -R 660 /var/games/pinball
	fowners -R root:gamestat /var/games/pinball
	fperms g+s /usr/bin/pinball
}
