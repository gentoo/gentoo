# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"
inherit autotools gnome2

MY_P="QtPixmap-${PV}"

DESCRIPTION="Theme engine based on GTK pixmap engine using the Plasma color scheme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=7043"
SRC_URI="http://www.cpdrummond.freeuk.com/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc sparc x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Add switches to enable/disable gtk1 and gtk2 engines in the configure
	# script.
	"${FILESDIR}"/${P}-gtk_switches.patch
)

src_prepare() {
	sed -i -e 's/AC_CHECK_COMPILERS/AC_PROG_CC/' configure.in || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die

	rm acinclude.m4 || die
	mv configure.{in,ac} || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-gtk2 \
		--disable-gtk1
}
