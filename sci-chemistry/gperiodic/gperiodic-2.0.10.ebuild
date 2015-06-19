# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gperiodic/gperiodic-2.0.10.ebuild,v 1.8 2012/09/05 07:03:30 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Periodic table application for Linux"
HOMEPAGE="http://www.frantz.fi/software/gperiodic.php"
SRC_URI="http://www.frantz.fi/software/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:5
	x11-libs/gtk+:2
	x11-libs/cairo[X]
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	# The author has removed "unnecessary automake/autoconf setup"

	sed -i -e "s|-DGTK_DISABLE_DEPRECATED|${CFLAGS}|" Makefile || die
	sed -i -e "/make clean/d" Makefile || die
	sed -i -e "s|CC=gcc|CC=$(tc-getCC)|" Makefile || die
	if ! use nls; then
		sed -i -e "/make -C po/d" Makefile || die
	fi
}

src_install() {
	sed -i -e "s|/usr/bin|${ED}/usr/bin|" Makefile || die
	sed -i -e "s|/usr/share|${ED}/usr/share|" Makefile || die
	sed -i -e "s|/usr/share|${ED}/usr/share|" po/Makefile || die

	# Create directories - Makefile is quite broken.
	dodir \
		/usr/bin \
		/usr/share/pixmaps \
		/usr/share/applications

	default

	# The man page seems to have been removed too.
	newdoc po/README README.translation
}
