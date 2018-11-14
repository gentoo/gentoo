# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils flag-o-matic gnome2-utils xdg-utils

DESCRIPTION="sakura is a terminal emulator based on GTK and VTE"
HOMEPAGE="http://www.pleyades.net/david/projects/sakura/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"

RDEPEND="
	>=dev-libs/glib-2.20:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	>x11-libs/vte-0.50:2.91
"
DEPEND="
	${RDEPEND}
	>=dev-lang/perl-5.10.1
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.3-flags.patch
)

DOCS=(
	AUTHORS
)

src_prepare() {
	sed -i "/FILES INSTALL/d" CMakeLists.txt || die

	strip-linguas -i po/
	local lingua
	for lingua in po/*.po; do
		lingua="${lingua/po\/}"
		lingua="${lingua/.po}"
		if ! has ${lingua} ${LINGUAS}; then
			rm po/${lingua}.po || die
		fi
	done

	cmake-utils_src_prepare
	# sakura.c:1740:3: warning: implicit declaration of function ‘readlink’
	# [-Wimplicit-function-declaration]
	append-cppflags -D_DEFAULT_SOURCE

	# sakura.c:1348:9: error: ‘for’ loop initial declarations are only allowed
	# in C99 or C11 mode
	append-cflags -std=c99
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
