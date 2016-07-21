# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib

DESCRIPTION="A Portable Implementation of the High-Performance Linpack Benchmark for Distributed-Memory Computers"
HOMEPAGE="http://www.netlib.org/benchmark/hpl/"
SRC_URI="http://www.netlib.org/benchmark/hpl/hpl-${PV}.tar.gz"

SLOT="0"
LICENSE="HPL"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="
	virtual/blas
	virtual/lapack
	virtual/mpi"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	local a=""
	local locallib="${EPREFIX}/usr/$(get_libdir)/lib"
	local localblas="$(for i in $($(tc-getPKG_CONFIG) --libs-only-l blas lapack);do a="${a} ${i/-l/${locallib}}.so "; done; echo ${a})"

	cp setup/Make.Linux_PII_FBLAS Make.gentoo_hpl_fblas_x86 || die
	sed -i \
		-e "/^TOPdir/s,= .*,= ${S}," \
		-e '/^HPL_OPTS\>/s,=,= -DHPL_DETAILED_TIMING -DHPL_COPY_L,' \
		-e '/^ARCH\>/s,= .*,= gentoo_hpl_fblas_x86,' \
		-e '/^MPdir\>/s,= .*,=,' \
		-e '/^MPlib\>/s,= .*,=,' \
		-e "/^LAlib\>/s,= .*,= ${localblas}," \
		-e '/^LINKER\>/s,= .*,= mpicc,' \
		-e '/^CC\>/s,= .*,= mpicc,' \
		-e '/^CCFLAGS\>/s|= .*|= $(HPL_DEFS) ${CFLAGS}|' \
		-e "/^LINKFLAGS\>/s|= .*|= ${LDFLAGS}|" \
		Make.gentoo_hpl_fblas_x86 || die
}

src_compile() {
	# parallel make failure bug #321539
	HOME=${WORKDIR} emake -j1 arch=gentoo_hpl_fblas_x86
}

src_install() {
	dobin bin/gentoo_hpl_fblas_x86/xhpl
	dolib lib/gentoo_hpl_fblas_x86/libhpl.a
	dodoc INSTALL BUGS COPYRIGHT HISTORY README TUNING \
		bin/gentoo_hpl_fblas_x86/HPL.dat
	doman man/man3/*.3
	if use doc; then
		dohtml -r www/*
	fi
}

pkg_postinst() {
	einfo "Remember to copy /usr/share/hpl/HPL.dat to your working directory"
	einfo "before running xhpl.  Typically one may run hpl by executing:"
	einfo "\"mpiexec -np 4 /usr/bin/xhpl\""
	einfo "where -np specifies the number of processes."
}
