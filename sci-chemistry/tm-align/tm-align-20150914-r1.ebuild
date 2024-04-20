# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic fortran-2

DESCRIPTION="Quick & Accurate Structural Alignment"
HOMEPAGE="https://zhanggroup.org/TM-align/"
SRC_URI="http://zhanglab.ccmb.med.umich.edu/TM-align/TMtools${PV}.tar.gz"
S="${WORKDIR}"

LICENSE="tm-align"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="custom-cflags"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	cmake_src_prepare

	# Recommended by upstream
	use custom-cflags || replace-flags -O* -O3 && append-fflags -ffast-math
}
