# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="sakura is a terminal emulator based on GTK and VTE"
HOMEPAGE="http://www.pleyades.net/david/projects/sakura/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~arm-linux ~x86-linux"

RDEPEND="
	>=dev-libs/glib-2.20:2
	>=x11-libs/vte-0.28:2.90
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10.1
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-3.1.3-flags.patch )

DOCS=( AUTHORS )

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
}
