# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cfitsio/cfitsio-3.360.ebuild,v 1.8 2015/07/15 16:23:10 klausman Exp $

EAPI=5

FORTRAN_NEEDED=fortran

inherit autotools-utils fortran-2

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="doc examples fortran static-libs +tools threads"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	fortran? ( dev-lang/cfortran )"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	# avoid internal cfortran
	if use fortran; then
		mv cfortran.h cfortran.h.disabled
		ln -s "${EPREFIX}"/usr/include/cfortran.h . || die
	fi
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable fortran)
		$(use_enable threads)
		$(use_enable tools)
	)
	autotools-utils_src_configure
}

src_install () {
	autotools-utils_src_install
	dodoc README* Changes* docs/changes.txt docs/cfitsio.doc
	use fortran && dodoc docs/fitsio.doc
	use doc && dodoc docs/{quick,cfitsio,fpackguide}.pdf
	use doc && use fortran && dodoc docs/fitsio.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins cookbook.c testprog.c speed.c smem.c
		use fortran && doins cookbook.f testf77.f
	fi
}
