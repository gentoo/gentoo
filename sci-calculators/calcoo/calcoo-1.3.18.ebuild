# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/calcoo/calcoo-1.3.18.ebuild,v 1.10 2012/08/04 21:08:01 bicatali Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit eutils autotools-utils

DESCRIPTION="Scientific calculator designed to provide maximum usability"
HOMEPAGE="http://calcoo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gold.patch )

src_configure() {
	local myeconfargs=( --disable-gtktest )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	newicon src/pixmaps/main.xpm ${PN}.xpm
	make_desktop_entry ${PN} Calcoo ${PN} "Education;Math"
}
