# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="libmcrypt is a library that provides uniform interface to access several encryption algorithms"
HOMEPAGE="http://mcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mcrypt/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-rotate-mask.patch
	mv configure.in configure.ac
	mv libltdl/configure.in libltdl/configure.ac
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac libltdl/configure.ac || die
	eautoreconf # need new libtool for interix (elibtoolize would suffice for freebsd)
}

src_install() {
	default
	dodoc AUTHORS NEWS README THANKS TODO ChangeLog
	dodoc doc/README.* doc/example.c
}
