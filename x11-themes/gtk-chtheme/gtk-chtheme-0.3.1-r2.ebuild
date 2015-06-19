# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-chtheme/gtk-chtheme-0.3.1-r2.ebuild,v 1.9 2012/05/05 04:10:03 jdhore Exp $

EAPI=3
inherit eutils toolchain-funcs

DESCRIPTION="GTK-2.0 Theme Switcher"
HOMEPAGE="http://plasmasturm.org/programs/gtk-chtheme/"
SRC_URI="http://plasmasturm.org/programs/gtk-chtheme/${P}.tar.bz2"

IUSE=""
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
LICENSE="GPL-2"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# QA: stop Makefile from stripping the binaries
	sed -i -e "s:strip:true:" "${S}"/Makefile || die "sed failed"
	epatch "${FILESDIR}"/${P}-implicit.patch

	# Fix forced as-needed, bug #248655
	epatch "${FILESDIR}/${P}-asneeded.patch"

	# Make it work with qgtkstyle, bug #250504
	epatch "${FILESDIR}/${P}-qgtkstyle.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
}
