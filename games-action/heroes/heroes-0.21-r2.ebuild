# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

data_ver=1.5
snd_trk_ver=1.0
snd_eff_ver=1.0

DESCRIPTION="Heroes Enjoy Riding Over Empty Slabs: similar to Tron and Nibbles"
HOMEPAGE="http://heroes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-data-${data_ver}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-tracks-${snd_trk_ver}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-effects-${snd_eff_ver}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ggi nls sdl"
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
		media-libs/libsdl
		media-libs/sdl-mixer
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
	local pkg
	for pkg in ${A//.tar.bz2}; do
		cd "${WORKDIR}"/${pkg} || die
		econf \
			--disable-heroes-debug \
			--disable-optimizations \
			$(use_with sdl) \
			$(use_with sdl sdl-mixer) \
			$(use_with ggi) \
			$(use_with ggi mikmod) \
			$(use_enable nls)
	done
}

src_install() {
	local pkg
	for pkg in ${A//.tar.bz2} ; do
		cd "${WORKDIR}"/${pkg} || die
		emake DESTDIR="${D}" install
	done
}
