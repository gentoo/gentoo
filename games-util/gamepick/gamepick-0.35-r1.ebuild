# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Launch opengl games with custom graphic settings"
HOMEPAGE="http://www.rillion.net/gamepick/index.html"
SRC_URI="http://www.rillion.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	sed -i \
		-e 's/-O2//' \
		src/Makefile.in || die
}

src_install() {
	default
	newicon ${PN}-48x48.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN}
}
