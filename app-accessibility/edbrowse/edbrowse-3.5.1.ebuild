# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils

DESCRIPTION="editor, browser, and mail client using the /bin/ed interface"
HOMEPAGE="http://the-brannons.com/edbrowse/"
SRC_URI="http://the-brannons.com/${PN}/${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_fr odbc"
COMMON_DEPEND=">=dev-lang/spidermonkey-24.0:24
	>=sys-libs/readline-6.0
	>=net-misc/curl-7.36.0
	>=dev-libs/libpcre-7.8
	>=dev-libs/openssl-0.9.8j
	odbc? ( dev-db/unixODBC )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	app-arch/unzip"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-implicit-decl.patch"
}

src_compile() {
		jscppflags=$(pkg-config --cflags mozjs-24)
		jslib=$(pkg-config --libs mozjs-24)
	emake prefix=/usr JSLIB="${jslib}" JS_CXXFLAGS="${jscppflags}" STRIP=''
	if use odbc; then
		# Top-level makefile doesn't have this target.
		cd src
	emake prefix=/usr JSLIB="${jslib}" JS_CXXFLAGS="${jscppflags}" STRIP=''
		cd ..
	fi
}

src_install() {
	cd src
	emake prefix=/usr DESTDIR="${D}" install
	if use odbc; then
		dobin edbrowseodbc
	fi
	cd ..
	dodoc CHANGES README todo
	cd doc
	dobin setup.ebrc
	dohtml usersguide.html philosophy.html
	dodoc sample.ebrc
	if use linguas_fr; then
		dohtml usersguide_fr.html philosophy_fr.html
		dodoc sample_fr.ebrc
	fi
}
