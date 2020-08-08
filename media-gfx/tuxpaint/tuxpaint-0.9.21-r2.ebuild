# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg-utils

DESCRIPTION="Drawing program designed for young children"
HOMEPAGE="http://www.tuxpaint.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="
	app-text/libpaper
	dev-libs/fribidi
	gnome-base/librsvg:2
	>=media-libs/libpng-1.2:0=
	>=media-libs/freetype-2:2
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	x11-libs/cairo
"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
"

DOCS=(
	docs/{ADVANCED-STAMPS-HOWTO,AUTHORS,CHANGES,default_colors,dejavu}.txt
	docs/{EXTENDING,FAQ,OPTIONS,PNG,README,SVG}.txt
)

PATCHES=(
	# Sanitize the Makefile and correct a few other issues
	"${FILESDIR}/${PN}-0.9.20-gentoo.patch"
	"${FILESDIR}/${P}-libpng1.5.patch" #378199
	"${FILESDIR}/${P}-LDFLAGS.patch" #334571
	"${FILESDIR}/${P}-underlinking.patch" #484434
)

src_prepare() {
	default
	sed -i \
		-e "s|linux_PREFIX:=/usr/local|linux_PREFIX:=/usr|" \
		-e "s:/lib/:/$(get_libdir)/:" \
		-e "s:/share/doc/tuxpaint.*:/share/doc/${PF}:g" \
		Makefile || die
}

src_compile() {
	# parallel build may break things
	emake -j1 CC="$(tc-getCC)" \
		$(use nls && echo ENABLE_GETTEXT=1)
}

src_install() {
	emake -j1 PKG_ROOT="${D}" \
		$(usex nls ENABLE_GETTEXT=1 '') install

	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update

	if ! has_version "${CATEGORY}/${PN}"; then
		elog "For additional graphic stamps, you can emerge the"
		elog "media-gfx/tuxpaint-stamps package."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
