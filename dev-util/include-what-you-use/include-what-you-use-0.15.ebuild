# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit cmake flag-o-matic llvm python-single-r1

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"

MY_KEYWORDS="~amd64 ~x86"

if [[ "${PV}" == "9999" ]] || [[ -n "${EGIT_COMMIT_ID}" ]]; then
	EGIT_REPO_URI="https://github.com/include-what-you-use/include-what-you-use.git"
	inherit git-r3
	if [[ "${PV}" == "9999" ]]; then
		MY_KEYWORDS=""
	fi
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/${PN}-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="${MY_KEYWORDS}"

LLVM_MAX_SLOT=11

RDEPEND="sys-devel/llvm:${LLVM_MAX_SLOT}
	sys-devel/clang:${LLVM_MAX_SLOT}
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	default
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
	"${EPYTHON}" run_iwyu_tests.py
}
