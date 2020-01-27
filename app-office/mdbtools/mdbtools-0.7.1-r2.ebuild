# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1 # needed for proper man generation
inherit autotools-utils

DESCRIPTION="Set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="http://mdbtools.sourceforge.net"
SRC_URI="https://github.com/brianb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"

IUSE="odbc static-libs"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	odbc? ( >=dev-db/unixODBC-2.0 )"
DEPEND="${RDEPEND}
	app-text/txt2man
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO )

PATCHES=( "${FILESDIR}/${P}-parallel-make.patch" )

src_configure() {
	local myeconfargs=(
		--disable-gtk-doc
		--disable-gmdb2
		$(use odbc && echo "--with-unixodbc=${EPREFIX}/usr")
	)
	autotools-utils_src_configure
}
