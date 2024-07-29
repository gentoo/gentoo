# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Portable Implementation of the Linpack Benchmark for Distributed-Memory Clusters"
HOMEPAGE="http://www.netlib.org/benchmark/hpl/"
SRC_URI="http://www.netlib.org/benchmark/hpl/hpl-${PV}.tar.gz"

SLOT="0"
LICENSE="HPL"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	virtual/blas
	virtual/lapack
	virtual/mpi"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.3-respect-AR.patch"
)

src_prepare() {
	default

	# Needed for the AR patch
	eautoreconf
}

src_install() {
	default

	doman man/man3/*.3
	dodoc testing/ptest/HPL.dat

	if use doc; then
		docinto html
		dodoc -r www/*
	fi
}

pkg_postinst() {
	einfo "Remember to copy (+ extract) ${EROOT}/usr/share/${PF}/HPL.dat.bzip2 to your working directory"
	einfo "before running xhpl. Typically one may run hpl by executing:"
	einfo "\"mpiexec -np 4 ${EROOT}/usr/bin/xhpl\""
	einfo "where -np specifies the number of processes."
}
