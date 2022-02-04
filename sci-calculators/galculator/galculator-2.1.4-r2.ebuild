# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="GTK+ based algebraic and RPN calculator"
HOMEPAGE="http://galculator.mnim.org/"
SRC_URI="http://galculator.mnim.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default

	# bug 566290
	echo "src/flex_parser.c" >> po/POTFILES.skip || die
}

src_install() {
	default
	dodoc doc/shortcuts

	mv "${ED}"/usr/share/{appdata,metainfo} || die
}
