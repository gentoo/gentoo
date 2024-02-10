# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=test

inherit autotools fortran-2 flag-o-matic

DEB_PR="1"

# https://github.com/bastien-roucaries/cfortran is for the Debian fork
DESCRIPTION="Header file allowing to call Fortran routines from C and C++"
HOMEPAGE="https://www-zeus.desy.de/~burow/cfortran/ https://github.com/bastien-roucaries/cfortran"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz"
SRC_URI+=" mirror://debian/pool/main/c/${PN}/${PN}_${PV}-${DEB_PR}.debian.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

src_prepare() {
	default

	if [[ -d "${WORKDIR}"/debian/patches ]] ; then
		eapply "${WORKDIR}"/debian/patches/
	fi

	eautoreconf

	if use examples; then
		# The examples are also used as tests and it's tricky to clean up
		# afterwards, just save a clean copy (sans Makefiles, as they only
		# cover the test phase) before the tests are run.
		cp -ar eg eg_src || die "Failed to preserve a clean copy of examples"
		rm -f eg_src/Makefile{,.am,.in}
	fi
}

src_configure() {
	use sparc && append-fflags $(test-flags-FC -fno-store-merging -fno-tree-slp-vectorize) # bug 818400
	append-cflags $(test-flags-CC -fcommon) # bug 899452
	default
}

src_install() {
	default

	# For compatibility with older versions
	dodir /usr/include/cfortran
	dosym -r /usr/include/cfortran.h /usr/include/cfortran/cfortran.h

	docinto debian
	dodoc "${WORKDIR}"/debian/{NEWS,changelog,copyright}

	if use examples; then
		docinto examples
		dodoc -r cfortest.c cfortex.f eg_src/*
	fi
}
