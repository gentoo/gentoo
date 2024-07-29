# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Clone of the famous PuyoPuyo game"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P}.tgz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

RDEPEND="
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod]
	opengl? ( media-libs/libglvnd )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-segfault.patch
)

src_prepare() {
	default

	rm data/sfx/._bi || die
}

src_compile() {
	tc-export CXX PKG_CONFIG

	emake PREFIX="${EPREFIX}"/usr ENABLE_OPENGL=$(usex opengl true false)
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install

	dodoc Changelog TODO
	doman man/flobopuyo.6

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry flobopuyo FloboPuyo
}
