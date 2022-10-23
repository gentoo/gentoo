# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake llvm python-single-r1

DESCRIPTION="Super-parallel Python port of the C-Reduce"
HOMEPAGE="https://github.com/marxin/cvise/"
SRC_URI="
	https://github.com/marxin/cvise/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

LLVM_MAX_SLOT=15
DEPEND="
	|| (
		sys-devel/clang:15
		sys-devel/clang:14
		sys-devel/clang:13
	)
	<sys-devel/clang-$(( LLVM_MAX_SLOT + 1 )):=
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/pebble[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	dev-util/unifdef
	sys-devel/flex
"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/flex
	test? (
		$(python_gen_cond_dep '
			dev-python/pebble[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-no-werror-cflags.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	python-single-r1_pkg_setup
	llvm_pkg_setup
}

src_test() {
	cd "${BUILD_DIR}" || die
	epytest
}

src_install() {
	cmake_src_install

	python_fix_shebang "${ED}"/usr/bin/cvise
}
