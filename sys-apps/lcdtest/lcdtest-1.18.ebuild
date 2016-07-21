# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit scons-utils eutils toolchain-funcs gnome2-utils

DESCRIPTION="Displays test patterns to spot dead/hot pixels on LCD screens"
HOMEPAGE="http://www.brouhaha.com/~eric/software/lcdtest/"
SRC_URI="http://www.brouhaha.com/~eric/software/lcdtest/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-libs/libsdl-1.2.7-r2[X,video]
	>=media-libs/sdl-image-1.2.3-r1
	>=media-libs/sdl-ttf-2.0.9
"
RDEPEND="${DEPEND}
	media-fonts/liberation-fonts
"

src_prepare() {
	epatch "${FILESDIR}/${PV}-build-system.patch"
	epatch_user
	sed -i -e \
		"s|/usr/share/fonts/liberation/|/usr/share/fonts/liberation-fonts/|" \
		src/lcdtest.c || die
}

src_configure() {
	tc-export CC
	myesconsargs=(
		--prefix="${EPREFIX}/usr"
	)
}

src_compile() {
	escons
}

src_install() {
	escons --buildroot="${D}" install
	dodoc README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
