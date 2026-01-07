# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

Sparse_PV="7.0.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Extended sparse matrix package"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${Sparse_P}/CXSparse"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Programs assume that they can access the Matrix folder in ${S}
	ln -s "${S}/Matrix" || die "cannot link to the Matrix folder"
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
