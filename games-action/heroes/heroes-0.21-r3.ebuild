# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Heroes Enjoy Riding Over Empty Slabs: similar to Tron and Nibbles"
HOMEPAGE="https://heroes.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-data-1.5.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-tracks-1.0.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-effects-1.0.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ggi nls +sdl"
REQUIRED_USE="^^ ( ggi sdl )"
RESTRICT="test"

RDEPEND="
	ggi? (
		media-libs/libggi
		media-libs/libgii
		media-libs/libmikmod
	)
	nls? ( virtual/libintl )
	sdl? (
		media-libs/libsdl[joystick,sound,video]
		media-libs/sdl-mixer[mod]
	)"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-gcc4.patch
	"${FILESDIR}"/${P}-cvs-segfault-fix.patch
	"${FILESDIR}"/${P}-compilation.patch
	"${FILESDIR}"/${P}-gcc10.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable nls)
		$(use_with ggi mikmod)
		$(use_with ggi)
		$(use_with sdl sdl-mixer)
		$(use_with sdl)
		--disable-heroes-debug
		--disable-optimizations
	)

	local pkg
	for pkg in ${A% *}; do
		cd "${WORKDIR}"/${pkg%.tar.bz2} || die
		econf "${econfargs[@]}"
	done
}

src_install() {
	local pkg
	for pkg in ${A% *}; do
		emake -C "${WORKDIR}"/${pkg%.tar.bz2} DESTDIR="${D}" install
	done

	einstalldocs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Heroes
}
