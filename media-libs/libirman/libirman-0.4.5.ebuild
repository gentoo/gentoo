# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils eutils toolchain-funcs

DESCRIPTION="library for Irman control of Unix software"
HOMEPAGE="http://www.lirc.org/software/snapshots/"
SRC_URI="http://www.lirc.org/software/snapshots/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="static-libs"

DOCS=( TECHNICAL NEWS README TODO )

src_prepare() {
	tc-export CC LD AR RANLIB
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install LIRC_DRIVER_DEVICE="${D}/dev/lirc"

	dobin ${AUTOTOOLS_BUILD_DIR}/test_{func,io,name}
}
