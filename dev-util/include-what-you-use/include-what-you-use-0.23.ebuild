# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
LLVM_COMPAT=( 19 )

inherit cmake llvm-r1 python-single-r1

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/llvm:${LLVM_SLOT}
	')
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm-r1_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	python_fix_shebang .

	rm tests/cxx/stdint.cc || die
}

src_configure() {
	local mycmakeargs=(
		# Note [llvm install path]
		# Unfortunately all binaries using clang driver
		# have to reside at the same path depth as
		# 'clang' binary itself. See bug #625972
		# Thus as a hack we install it to the same directory
		# as llvm/clang itself.
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
	)
	cmake_src_configure
}

src_test() {
	local clang_version=$(best_version sys-devel/clang:${LLVM_SLOT})
	clang_version=${clang_version#*/*-} # reduce it to ${PV}-${PR}
	clang_version=${clang_version%%[_-]*} # main version without beta/pre/patch/revision

	local clang_include_dir_candidates=(
		"${ESYSROOT}/usr/lib/clang/${clang_version}/include"
		"${ESYSROOT}/usr/lib/clang/${LLVM_SLOT}/include"
	)

	local candidate_dir
	for candidate_dir in "${clang_include_dir_candidates[@]}"; do
		if [[ -d "${candidate_dir}" ]]; then
			local clang_include_dir="${candidate_dir}"
			break
		fi
	done

	if [[ ! -v clang_include_dir ]]; then
		die "Could not infer clang include directory. Candidates: ${clang_include_dir_candidates[*]}"
	fi

	local -x IWYU_EXTRA_ARGS="-I ${clang_include_dir}"
	"${EPYTHON}" run_iwyu_tests.py \
				 -- "${BUILD_DIR}"/bin/${PN} \
		|| die "Tests failed with $? (using ${EPYTHON})"
}
