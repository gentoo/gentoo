# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Extended sparse matrix package"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/CXSparse"
LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}"
RDEPEND="${DEPEND}"

src_configure() {
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Programs assume that they can access the Matrix folder in ${S}
	ln -s "${S}/Matrix"
	# Run demo files
	./cs_idemo < Matrix/t2 || die "failed testing"
	./cs_ldemo < Matrix/t2 || die "failed testing"
	./cs_demo1 < Matrix/t1 || die "failed testing"
	./cs_demo2 < Matrix/t1 || die "failed testing"
	./cs_demo2 < Matrix/fs_183_1 || die "failed testing"
	./cs_demo2 < Matrix/west0067 || die "failed testing"
	./cs_demo2 < Matrix/lp_afiro || die "failed testing"
	./cs_demo2 < Matrix/ash219 || die "failed testing"
	./cs_demo2 < Matrix/mbeacxc || die "failed testing"
	./cs_demo2 < Matrix/bcsstk01 || die "failed testing"
	./cs_demo3 < Matrix/bcsstk01 || die "failed testing"
	./cs_demo2 < Matrix/bcsstk16 || die "failed testing"
	./cs_demo3 < Matrix/bcsstk16 || die "failed testing"
	./cs_di_demo1 < Matrix/t1 || die "failed testing"
	./cs_di_demo2 < Matrix/t1 || die "failed testing"
	./cs_di_demo2 < Matrix/fs_183_1 || die "failed testing"
	./cs_di_demo2 < Matrix/west0067 || die "failed testing"
	./cs_di_demo2 < Matrix/lp_afiro || die "failed testing"
	./cs_di_demo2 < Matrix/ash219 || die "failed testing"
	./cs_di_demo2 < Matrix/mbeacxc || die "failed testing"
	./cs_di_demo2 < Matrix/bcsstk01 || die "failed testing"
	./cs_di_demo3 < Matrix/bcsstk01 || die "failed testing"
	./cs_di_demo2 < Matrix/bcsstk16 || die "failed testing"
	./cs_di_demo3 < Matrix/bcsstk16 || die "failed testing"
	./cs_dl_demo1 < Matrix/t1 || die "failed testing"
	./cs_dl_demo2 < Matrix/t1 || die "failed testing"
	./cs_dl_demo2 < Matrix/fs_183_1 || die "failed testing"
	./cs_dl_demo2 < Matrix/west0067 || die "failed testing"
	./cs_dl_demo2 < Matrix/lp_afiro || die "failed testing"
	./cs_dl_demo2 < Matrix/ash219 || die "failed testing"
	./cs_dl_demo2 < Matrix/mbeacxc || die "failed testing"
	./cs_dl_demo2 < Matrix/bcsstk01 || die "failed testing"
	./cs_dl_demo3 < Matrix/bcsstk01 || die "failed testing"
	./cs_dl_demo2 < Matrix/bcsstk16 || die "failed testing"
	./cs_dl_demo3 < Matrix/bcsstk16 || die "failed testing"
	./cs_ci_demo1 < Matrix/t2 || die "failed testing"
	./cs_ci_demo2 < Matrix/t2 || die "failed testing"
	./cs_ci_demo2 < Matrix/t3 || die "failed testing"
	./cs_ci_demo2 < Matrix/t4 || die "failed testing"
	./cs_ci_demo2 < Matrix/c_west0067 || die "failed testing"
	./cs_ci_demo2 < Matrix/c_mbeacxc || die "failed testing"
	./cs_ci_demo2 < Matrix/young1c || die "failed testing"
	./cs_ci_demo2 < Matrix/qc324 || die "failed testing"
	./cs_ci_demo2 < Matrix/neumann || die "failed testing"
	./cs_ci_demo2 < Matrix/c4 || die "failed testing"
	./cs_ci_demo3 < Matrix/c4 || die "failed testing"
	./cs_ci_demo2 < Matrix/mhd1280b || die "failed testing"
	./cs_ci_demo3 < Matrix/mhd1280b || die "failed testing"
	./cs_cl_demo1 < Matrix/t2 || die "failed testing"
	./cs_cl_demo2 < Matrix/t2 || die "failed testing"
	./cs_cl_demo2 < Matrix/t3 || die "failed testing"
	./cs_cl_demo2 < Matrix/t4 || die "failed testing"
	./cs_cl_demo2 < Matrix/c_west0067 || die "failed testing"
	./cs_cl_demo2 < Matrix/c_mbeacxc || die "failed testing"
	./cs_cl_demo2 < Matrix/young1c || die "failed testing"
	./cs_cl_demo2 < Matrix/qc324 || die "failed testing"
	./cs_cl_demo2 < Matrix/neumann || die "failed testing"
	./cs_cl_demo2 < Matrix/c4 || die "failed testing"
	./cs_cl_demo3 < Matrix/c4 || die "failed testing"
	./cs_cl_demo2 < Matrix/mhd1280b || die "failed testing"
	./cs_cl_demo3 < Matrix/mhd1280b || die "failed testing"
}
