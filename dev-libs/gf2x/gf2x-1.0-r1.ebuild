# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

PACKAGEID=27999 # hack

DESCRIPTION="C/C++ routines for fast arithmetic in GF(2)[x]"
HOMEPAGE="http://gf2x.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/${PACKAGEID}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="bindist static-libs"

src_configure() {
	local myeconfargs=(
		ABI=default
		)

	if use bindist ; then
		if use x86 ; then
			myeconfargs+=(
				--disable-sse2
			)
		fi
		if use amd64 ; then
			myeconfargs+=(
				--disable-pclmul
			)
		fi
	fi

	autotools-utils_src_configure
}
