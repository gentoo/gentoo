# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="http://mdbtools.sourceforge.net"
SRC_URI="https://github.com/brianb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="odbc"

BDEPEND="
	app-text/txt2man
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"
RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	odbc? ( >=dev-db/unixODBC-2.0 )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO )

PATCHES=( "${FILESDIR}/${P}-parallel-make.patch" )

src_prepare() {
	default

	# bug #697568
	sed -i -e "s:/lib\":/$(get_libdir)\":" configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-gtk-doc
		--disable-gmdb2
		--disable-static
		$(use odbc && echo "--with-unixodbc=${EPREFIX}/usr")
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
