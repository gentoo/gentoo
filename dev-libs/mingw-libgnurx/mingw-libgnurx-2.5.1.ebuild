# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="GNU regex library ripped out of glibc for use with mingw apps"
HOMEPAGE="http://mingw.sourceforge.net/"
SRC_URI="mirror://sourceforge/mingw/${P}-src.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

# Installs regex.h which most C libs provide.
RDEPEND="!sys-libs/glibc
	!sys-libs/uclibc
	!sys-libs/musl"

src_prepare() {
	default

	# Refresh the autotools to modern ones as the bundled ones are ancient.
	rm aclocal.m4
	cat <<EOF >configure.ac
AC_INIT(libgnurx, ${PV})
AM_INIT_AUTOMAKE
LT_INIT([dlopen win32-dll])
AC_OUTPUT([Makefile])
EOF
	cat <<EOF >Makefile.am
include_HEADERS = regex.h
lib_LTLIBRARIES = libgnurx.la
libgnurx_la_SOURCES = regex.c
libgnurx_la_LDFLAGS = -no-undefined -version-info 0:0:0 -export-dynamic
EOF

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
