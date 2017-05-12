# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

DESCRIPTION="A Window Matching utility similar to Sawfish's Matched Windows feature"
HOMEPAGE="http://www.burtonini.com/blog/tag/devilspie.html"
SRC_URI="http://www.burtonini.com/computing/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.10
	x11-libs/gtk+:3[X]
	x11-libs/libwnck:3
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	gnome-base/gnome-common" # Required by eautoreconf

src_prepare() {
	default
	sed -i -e "s:\(/usr/share/doc/devilspie\):\1-${PVR}:" devilspie.1 || die
	sed -i -e '/-DG.*_DISABLE_DEPRECATED/d' src/Makefile.am || die
	mv configure.{in,ac} || die
	eautoreconf
	LIBS="$($(tc-getPKG_CONFIG) --libs x11)"
}

src_install() {
	default
	keepdir /etc/devilspie
}
