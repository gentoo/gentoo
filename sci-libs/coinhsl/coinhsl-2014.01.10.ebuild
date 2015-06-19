# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinhsl/coinhsl-2014.01.10.ebuild,v 1.1 2014/01/15 19:44:11 bicatali Exp $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=yes
FORTRAN_STANDARD="77 90"

inherit autotools-utils fortran-2 toolchain-funcs

DESCRIPTION="HSL mathematical software library for IPOPT"
HOMEPAGE="http://www.hsl.rl.ac.uk/ipopt"
SRC_URI="${P}.tar.gz"

LICENSE="HSL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	sci-libs/metis
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror fetch"

src_configure() {
	export LIBS="$($(tc-getPKG_CONFIG) --libs metis blas lapack)"
	autotools-utils_src_configure
	MAKEOPTS+=" -j1"
}
