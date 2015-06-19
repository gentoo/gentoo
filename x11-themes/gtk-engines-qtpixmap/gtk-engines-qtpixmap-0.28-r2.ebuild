# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-qtpixmap/gtk-engines-qtpixmap-0.28-r2.ebuild,v 1.12 2013/09/29 09:30:01 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

MY_P="QtPixmap-${PV}"

DESCRIPTION="A modified version of the original GTK pixmap engine which follows the KDE color scheme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=7043"
SRC_URI="http://www.cpdrummond.freeuk.com/${MY_P}.tar.gz"

KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"

IUSE=""

RDEPEND="x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Add switches to enable/disable gtk1 and gtk2 engines in the configure
	# script.
	epatch "${FILESDIR}/${P}-gtk_switches.patch"

	sed -i -e 's/AC_CHECK_COMPILERS/AC_PROG_CC/' configure.in || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die

	rm acinclude.m4

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-gtk2 \
		--disable-gtk1
}
