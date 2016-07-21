# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

MY_P="${PN}"

DESCRIPTION="MySQL monitor dockapp"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/42"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/73/${P}.tar.gz"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	>=virtual/mysql-4.0"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i "s/make/\$(MAKE)/g" src/Makefile || die
}

src_compile() {
	cd "${S}"/src
	emake clean || die
	emake CFLAGS="${CFLAGS}" SYSTEM="${LDFLAGS}" || die
}

src_install() {
	cd "${S}"/src
	dobin wmjsql || die
	newdoc conf sample.wmjsql

	cd "${S}"
	dodoc CREDITS README TODO

	domenu "${FILESDIR}"/${PN}.desktop
}
