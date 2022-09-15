# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	x11-libs/cairo
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gperf
	media-gfx/imagemagick[jpeg,png,svg]
	sys-devel/gettext
"

src_prepare() {
	xdg_src_prepare

	sed -i \
		-e 's|linux_ARCH_INSTALL:=install-xdg|linux_ARCH_INSTALL:=|' \
		-e "s|linux_PREFIX:=/usr/local|linux_PREFIX:=/usr|" \
		-e "s:/lib/:/$(get_libdir)/:g" \
		-e 's:/share/doc/tuxpaint-$(VER_VERSION)/:'"/share/doc/${PF}/:g" \
		-e '/@gzip -f/d' \
		-e '/@chmod a+rx,g-w,o-w $(MAN_PREFIX)/d' \
		-e "s|linux_ARCH_CFLAGS:=|linux_ARCH_CFLAGS:= ${CFLAGS}|" \
		Makefile || die
}

src_compile() {
	# parallel build may break things
	emake -j1 CC="$(tc-getCC)"
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
