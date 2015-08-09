# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="A tool for exporting C libraries into Scheme"
HOMEPAGE="http://www.nongnu.org/g-wrap/"
SRC_URI="http://download.savannah.gnu.org/releases/g-wrap/${P}.tar.gz"
KEYWORDS="amd64 hppa ppc ppc64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

# guile-lib for srfi-34, srfi-35
RDEPEND="
	dev-libs/glib:2
	dev-scheme/guile-lib
	dev-scheme/guile[deprecated]
	virtual/libffi"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

MAKEOPTS+=" -j1"

src_prepare() {
#	cp guile/g-wrap-2.0-guile.pc.in guile/g-wrap-2.0-guile.pc.in.old

	sed "s:@LIBFFI_CFLAGS_INSTALLED@:@LIBFFI_CFLAGS@:g" -i guile/g-wrap-2.0-guile.pc.in || die
	sed "s:@LIBFFI_LIBS_INSTALLED@:@LIBFFI_LIBS@:g" -i guile/g-wrap-2.0-guile.pc.in || die

#	diff -u guile/g-wrap-2.0-guile.pc.in.old guile/g-wrap-2.0-guile.pc.in
}

src_configure() {
	econf --with-glib --disable-Werror
}
