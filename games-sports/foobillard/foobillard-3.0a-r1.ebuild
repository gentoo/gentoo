# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic toolchain-funcs

DESCRIPTION="8ball, 9ball, snooker and carambol game"
HOMEPAGE="https://foobillard.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl video_cards_nvidia"

RDEPEND="x11-libs/libXaw
	x11-libs/libXi
	virtual/opengl
	virtual/glu
	>=media-libs/freetype-2.0.9:2
	media-libs/libpng:0=
	sdl? ( media-libs/libsdl[video] )
	!sdl? ( media-libs/freeglut )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-no_nvidia.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
	"${FILESDIR}"/${P}-fbsd.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-gl-clamp.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	rm aclocal.m4

	tc-export PKG_CONFIG

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/859235
	#
	# Upstream is sourceforge, and dead since 2010. Not reported upstream.
	filter-lto

	use video_cards_nvidia && append-ldflags -L/usr/$(get_libdir)/opengl/nvidia/lib
	econf \
		--enable-sound \
		$(use_enable sdl SDL) \
		$(use_enable !sdl glut) \
		$(use_enable video_cards_nvidia nvidia)
}

src_install() {
	default
	doman foobillard.6
	newicon data/full_symbol.png foobillard.png
	make_desktop_entry foobillard Foobillard
}
