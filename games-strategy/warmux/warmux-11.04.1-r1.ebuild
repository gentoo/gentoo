# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="A free Worms clone"
HOMEPAGE="http://gna.org/projects/warmux/"
SRC_URI="http://download.gna.org/warmux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug nls unicode"

RDEPEND="
	dev-libs/libxml2
	media-libs/libsdl[joystick,video,X]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-net
	media-libs/sdl-gfx
	media-fonts/dejavu
	net-misc/curl
	x11-libs/libX11
	nls? ( virtual/libintl )
	unicode? ( dev-libs/fribidi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-11.04

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-action.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-stat.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-localedir-name="${EPREFIX}"/usr/share/locale \
		--with-datadir-name="${EPREFIX}"/usr/share/${PN} \
		--with-font-path="${EPREFIX}"/usr/share/fonts/dejavu/DejaVuSans.ttf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable unicode fribidi)
}

src_install() {
	default

	rm -f "${ED%/}"/usr/share/${PN}/font/DejaVuSans.ttf || die
	doicon data/icon/warmux.svg
	make_desktop_entry warmux Warmux
}
