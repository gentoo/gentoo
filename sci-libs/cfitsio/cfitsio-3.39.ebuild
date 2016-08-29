# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED=fortran

inherit fortran-2 multilib-minimal

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="bzip2 doc examples fortran static-libs +tools threads"

RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )"
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
	default
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable fortran) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_enable tools) \
		$(use_with bzip2)
}

multilib_src_install_all() {
	dodoc README README.md CHANGES.md docs/changes.txt docs/cfitsio.doc
	use fortran && dodoc docs/fitsio.doc
	use doc && dodoc docs/{quick,cfitsio,fpackguide}.pdf
	use doc && use fortran && dodoc docs/fitsio.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins cookbook.c testprog.c speed.c smem.c
		use fortran && doins cookbook.f testf77.f
	fi
	prune_libtool_files --all
}
