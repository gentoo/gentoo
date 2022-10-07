# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature toolchain-funcs xdg

DESCRIPTION="Drawing program designed for young children"
HOMEPAGE="http://www.tuxpaint.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	app-text/libpaper:=
	dev-libs/fribidi
	gnome-base/librsvg:2
	>=media-libs/libpng-1.2:0=
	>=media-libs/freetype-2:2
	media-libs/libsdl[joystick]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	media-libs/sdl-gfx
	media-gfx/libimagequant
	x11-libs/cairo
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gperf
	media-gfx/graphicsmagick[jpeg,png,svg]
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_compile() {
	# parallel build may break things
	emake -j1 CC="$(tc-getCC)" LIBDIR="$(get_libdir)"
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	local file size
	for file in data/images/icon[0-9]*x[0-9]*.png; do
		size=${file##*/icon}
		size=${size%%x*}
		newicon -s "${size}" "${file}" tux4kids-tuxpaint.png
	done
	newmenu src/tuxpaint.desktop tux4kids-tuxpaint.desktop
	dodoc docs/*.txt
	dodoc docs/en/*.txt
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "additional graphic stamps" media-gfx/tuxpaint-stamps
}
