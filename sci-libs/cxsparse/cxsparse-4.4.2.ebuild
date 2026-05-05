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
	ln -s "${S}/Matrix" || die
	# cs_demo2, cs_di_demo2, cs_dl_demo2
	local demo_set_1=(
		ash219
		bcsstk01
		bcsstk16
		fs_183_1
		lp_afiro
		mbeacxc
		t1
		west0067
	)
	# cs_demo3, cs_di_demo3, cs_dl_demo3
	local demo_set_2=(
		bcsstk01
		bcsstk16
	)
	# cs_ci_demo2, cs_cl_demo2
	local demo_set_3=(
		c4
		c_mbeacxc
		c_west0067
		mhd1280b
		neumann
		qc324
		t2
		t3
		t4
		young1c
	)
	# cs_ci_demo3, cs_cl_demo3
	local demo_set_4=(
		c4
		mhd1280b
	)

	declare -A testsuite
	testsuite+=(
		["cs_idemo"]=t2
		["cs_ldemo"]=t2

		["cs_demo1"]=t1
		["cs_demo2"]=${demo_set_1[@]}
		["cs_demo3"]=${demo_set_2[@]}

        ["cs_ci_demo1"]=t2
        ["cs_ci_demo2"]=${demo_set_3[@]}
        ["cs_ci_demo3"]=${demo_set_4[@]}

        ["cs_cl_demo1"]=t2
        ["cs_cl_demo2"]=${demo_set_3[@]}
        ["cs_cl_demo3"]=${demo_set_4[@]}

        ["cs_di_demo1"]=t1
        ["cs_di_demo2"]=${demo_set_1[@]}
        ["cs_di_demo3"]=${demo_set_2[@]}

        ["cs_dl_demo1"]=t1
        ["cs_dl_demo2"]=${demo_set_1[@]}
        ["cs_dl_demo3"]=${demo_set_2[@]}
	)

	# Run demo files
	local i
	local j
	for i in ${!testsuite[@]}; do
		for j in ${testsuite[${i[@]}]}; do
			./${i} < Matrix/${j} || die "failed testing ${i} with ${j}"
		done
	done
	einfo "All tests passed"
}
