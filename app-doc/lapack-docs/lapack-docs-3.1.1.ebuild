# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Documentation reference and man pages for lapack implementations"
HOMEPAGE="https://www.netlib.org/lapack"
SRC_URI="mirror://gentoo/lapack-man-${PV}.tgz
	http://www.netlib.org/lapack/lapackqref.ps"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE=""

S="${WORKDIR}/lapack-${PV}/manpages"

src_install() {
	# These belong to blas-docs
	rm -f man/manl/{lsame,xerbla}.* || die

	# rename because doman does not yet understand manl files
	local f t
	for f in man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}" || die
	done

	doman man/manl/*
	dodoc README "${DISTDIR}"/lapackqref.ps
}
