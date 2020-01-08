# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Documentation reference and man pages for blas implementations"
HOMEPAGE="http://www.netlib.org/blas"
SRC_URI="mirror://gentoo/lapack-man-${PV}.tgz
	http://www.netlib.org/blas/blasqr.ps
	http://www.netlib.org/blas/blast-forum/blas-report.ps"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

S=${WORKDIR}/lapack-${PV}/manpages

src_install() {
	# rename because doman does not yet understand manl files
	local f t
	for f in blas/man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}" || die
	done

	doman blas/man/manl/*.n
	dodoc README "${DISTDIR}"/blas{-report,qr}.ps
}
