# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic fortran-2

DESCRIPTION="Quick & Accurate Structural Alignment"
HOMEPAGE="https://zhanggroup.org/TM-align/"
SRC_URI="http://zhanglab.ccmb.med.umich.edu/TM-align/TMtools${PV}.tar.gz"

LICENSE="tm-align"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE="custom-cflags"

BDEPEND=">=dev-build/cmake-3.28"

src_unpack() {
	# S=${WORKDIR} is deprecated in cmake eclass
	mkdir "${P}" || die
	pushd "${P}" || die
		unpack ${A}
	popd || die
}

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	cmake_src_prepare

	# Recommended by upstream
	use custom-cflags || replace-flags -O* -O3 && append-fflags -ffast-math
}
