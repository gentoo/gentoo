# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="https://github.com/mdbtools/mdbtools"
SRC_URI="https://github.com/brianb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86"
IUSE="glib odbc"

BDEPEND="
	app-text/txt2man
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"
RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	virtual/libiconv
	glib? ( dev-libs/glib:2 )
	odbc? ( >=dev-db/unixODBC-2.0 )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS HACKING NEWS README.md )

src_prepare() {
	default

	# bug #770019
	sed -i -e 's/-Werror//' configure.ac || die

	eautoreconf
}

src_configure() {
	# TODO: Make iconv optional

	local myeconfargs=(
		--disable-static
		$(use_enable glib)
		$(use odbc && echo "--with-unixodbc=${EPREFIX}/usr")
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
