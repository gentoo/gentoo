# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils gnome2-utils multilib toolchain-funcs

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
	gnome-base/librsvg
	>=media-libs/libpng-1.2
	>=media-libs/freetype-2
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	x11-libs/cairo"

DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	# Sanitize the Makefile and correct a few other issues.
	epatch "${FILESDIR}/${PN}-0.9.20-gentoo.patch"
	epatch "${FILESDIR}/${P}-libpng1.5.patch" #378199
	epatch "${FILESDIR}/${P}-LDFLAGS.patch" #334571
	epatch "${FILESDIR}/${P}-underlinking.patch" #484434

	sed -i \
		-e "s|linux_PREFIX:=/usr/local|linux_PREFIX:=/usr|" \
		-e "s:/lib/:/$(get_libdir)/:" \
		-e "s:/share/doc/tuxpaint.*:/share/doc/${PF}:g" \
		Makefile || die
}

src_compile() {
	# emake may break things
	make CC="$(tc-getCC)" \
		$(use nls && echo ENABLE_GETTEXT=1) || die "Compilation failed"
}

src_install () {
	make PKG_ROOT="${D}" \
		$(use nls && echo ENABLE_GETTEXT=1) install || die "Installation failed"

	rm -f docs/COPYING.txt docs/INSTALL.txt
	dodoc docs/*.txt
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog ""
	elog "For additional graphic stamps, you can emerge the"
	elog "media-gfx/tuxpaint-stamps package."
	elog ""
}
