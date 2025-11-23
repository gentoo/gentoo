# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="https://github.com/mdbtools/mdbtools"
SRC_URI="https://github.com/mdbtools/mdbtools/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE="glib iconv odbc"

BDEPEND="
	app-text/txt2man
	sys-devel/bison
	sys-devel/flex
	sys-apps/which
	virtual/pkgconfig
"
RDEPEND="
	sys-libs/ncurses:=
	sys-libs/readline:=
	glib? ( >=dev-libs/glib-2.68:2 )
	iconv? ( virtual/libiconv )
	odbc? ( >=dev-db/unixODBC-2.0 )
"
DEPEND="${RDEPEND}"

src_configure() {
	# bug #915495
	unset YACC LEX

	local myeconfargs=(
		$(use_enable glib)
		$(use_enable iconv)
		$(use odbc && echo "--with-unixodbc=${EPREFIX}/usr")
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
