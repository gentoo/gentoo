# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2-utils multilib toolchain-funcs

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
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

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

src_install () {
	emake -j1 PKG_ROOT="${D}" \
		$(use nls && echo ENABLE_GETTEXT=1) install

	rm -f docs/COPYING.txt docs/INSTALL.txt
	dodoc docs/*.txt
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if ! has_version "${CATEGORY}/${PN}"; then
		elog ""
		elog "For additional graphic stamps, you can emerge the"
		elog "media-gfx/tuxpaint-stamps package."
		elog ""
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
