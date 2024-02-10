# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake llvm python-single-r1

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/include-what-you-use/include-what-you-use/commit/62e5e2e35380e46ccbff2c2ed118f8bb5c01755b.patch
		-> ${PN}-0.19-test-util-support-EXTRA_IWYU_ARGS.patch
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

LLVM_MAX_SLOT=15

RDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	sys-devel/llvm:${LLVM_MAX_SLOT}
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	# https://github.com/include-what-you-use/include-what-you-use/pull/1252
	"${DISTDIR}"/${PN}-0.19-test-util-support-EXTRA_IWYU_ARGS.patch
	"${FILESDIR}"/${PN}-0.19-tests-cxx-badinc.cc-remove-stddef-from-expected.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		# Note [llvm install path]
		# Unfortunately all binaries using clang driver
		# have to reside at the same path depth as
		# 'clang' binary itself. See bug #625972
		# Thus as a hack we install it to the same directory
		# as llvm/clang itself.
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
	)
	cmake_src_configure
}

src_test() {
	local clang_version=$(best_version sys-devel/clang:${LLVM_MAX_SLOT})
	clang_version=${clang_version#*/*-} # reduce it to ${PV}-${PR}
	clang_version=${clang_version%%[_-]*} # main version without beta/pre/patch/revision

	local -x EXTRA_IWYU_ARGS="-I ${ESYSROOT}/usr/lib/clang/${clang_version}/include"
	"${EPYTHON}" run_iwyu_tests.py \
				 -- "${BUILD_DIR}"/bin/${PN} \
		|| die "Tests failed with $? (using ${EPYTHON})"
}
