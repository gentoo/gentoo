# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit eutils multilib wxwidgets

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="mirror://sourceforge/wxcode/${P}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	x11-libs/wxGTK:3.0[X,debug=]
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${P%.1}"

src_prepare() {
	local wxdebug

	rm -rf sqlite3 || die
	cp configure30 configure || die
	use debug && wxdebug="d"
	sed \
		-e "s:@WXDEBUG@:${wxdebug}:g" \
		-e "s:@WXVERSION@:${WX_GTK_VER}:g" \
		-e "s:@LIBDIR@:$(get_libdir):g" \
		-e "s:@VERSION@:${PV}:g" \
		"${FILESDIR}"/${P}.pc.in > ${PN}.pc || die
}

src_configure() {
	econf \
		--enable-shared \
		--enable-unicode \
		--with-wx-config="${WX_CONFIG}" \
		--with-wxshared \
		--with-sqlite3-prefix="${PREFIX}/usr"
}

src_install() {
	default

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	dodoc Readme.txt
	dohtml -r docs/html/*
	docinto samples
	dodoc -r samples/*
}
