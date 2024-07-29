# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature toolchain-funcs xdg

DESCRIPTION="Drawing program designed for young children"
HOMEPAGE="https://www.tuxpaint.org/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="
	app-text/libpaper:=
	dev-libs/fribidi
	gnome-base/librsvg:2
	media-gfx/libimagequant
	>=media-libs/freetype-2:2
	>=media-libs/libpng-1.2:0=
	media-libs/libsdl2[X,joystick]
	media-libs/sdl2-gfx
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer
	media-libs/sdl2-pango
	media-libs/sdl2-ttf
	sys-libs/zlib
	x11-libs/cairo
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gperf
	media-gfx/graphicsmagick[jpeg,png]
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)" GENTOO_LIBDIR="$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" GENTOO_LIBDIR="$(get_libdir)" install
	local file size
	for file in data/images/icon[0-9]*x[0-9]*.png; do
		size=${file##*/icon}
		size=${size%%x*}
		newicon -s "${size}" "${file}" tux4kids-tuxpaint.png
	done
	newmenu src/tuxpaint.desktop tux4kids-tuxpaint.desktop
	docinto /usr/share/doc/${PF}
	dodoc docs/*.txt
	dodoc docs/en/*.txt
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "additional graphic stamps" media-gfx/tuxpaint-stamps
}
