# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit wxwidgets

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="mirror://sourceforge/wxcode/${P}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	dev-db/sqlite:3"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	rm -r sqlite3 || die
	cp configure30 configure || die
	sed \
		-e "s:@WXVERSION@:${WX_GTK_VER}:g" \
		-e "s:@LIBDIR@:$(get_libdir):g" \
		-e "s:@VERSION@:${PV}:g" \
		"${FILESDIR}"/${P}.pc.in > ${PN}.pc || die
}

src_configure() {
	setup-wxwidgets
	econf \
		--enable-shared \
		--enable-unicode \
		--with-wx-config="${WX_CONFIG}" \
		--with-wxshared \
		--with-sqlite3-prefix="${ESYSROOT}"/usr
}

src_install() {
	HTML_DOCS=( docs/html/. )
	default

	dodoc Readme.txt
	dodoc -r samples

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
