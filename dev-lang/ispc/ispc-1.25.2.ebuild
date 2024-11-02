# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..19} )
PYTHON_COMPAT=( python3_{10..13} )

inherit cmake llvm-r1 multiprocessing python-any-r1 toolchain-funcs

DESCRIPTION="Intel SPMD Program Compiler"
HOMEPAGE="
	https://ispc.github.io/
	https://github.com/ispc/ispc/
"
SRC_URI="
	https://github.com/ispc/ispc/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD BSD-2 UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="examples gpu openmp test"
RESTRICT="!test? ( test )"

DEPEND="
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
	')
	sys-libs/ncurses:=
	gpu? ( dev-libs/level-zero:= )
	!openmp? ( dev-cpp/tbb:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	${PYTHON_DEPS}
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	llvm-r1_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	# do not require bundled gtest
	mkdir -p ispcrt/tests/vendor/google/googletest || die
	cat > ispcrt/tests/vendor/google/googletest/CMakeLists.txt <<-EOF || die
		find_package(GTest)
	EOF
	# remove hacks that break unbundling
	sed -i -e '/gmock/d' -e '/install/,$d' ispcrt/tests/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DARM_ENABLED=$(usex arm)
		-DCMAKE_SKIP_RPATH=ON
		-DISPC_INCLUDE_EXAMPLES=OFF
		-DISPC_INCLUDE_TESTS=$(usex test)
		-DISPC_INCLUDE_UTILS=OFF
		-DISPCRT_BUILD_GPU=$(usex gpu)
		-DISPCRT_BUILD_TASK_MODEL=$(usex openmp OpenMP TBB)
		# prevent it from trying to find the git repo
		-DGIT_BINARY=GIT_BINARY-NOTFOUND
	)
	cmake_src_configure
}

src_test() {
	# Inject path to prevent using system ispc
	local -x PATH="${BUILD_DIR}/bin:${PATH}"
	"${EPYTHON}" ./scripts/run_tests.py "-j$(makeopts_jobs)" -v ||
		die "Testing failed under ${EPYTHON}"
}

src_install() {
	cmake_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
