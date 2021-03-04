# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
PYTHON_COMPAT=( python3_{7..9} )
inherit cmake llvm python-single-r1

DESCRIPTION="Super-parallel Python port of the C-Reduce"
HOMEPAGE="https://github.com/marxin/cvise/"
SRC_URI="
	https://github.com/marxin/cvise/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

LLVM_MAX_SLOT=11
DEPEND="
	|| (
		sys-devel/clang:11
		sys-devel/clang:10
	)
	<=sys-devel/clang-$(( LLVM_MAX_SLOT + 1 )):="
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pebble[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	dev-util/unifdef
	sys-devel/flex"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/flex
	test? (
		$(python_gen_cond_dep '
			dev-python/pebble[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	python-single-r1_pkg_setup
	llvm_pkg_setup
}

src_prepare() {
	sed -i -e 's:-n auto::' -e 's:--flake8::' setup.cfg || die
	cmake_src_prepare
}

src_test() {
	cd "${BUILD_DIR}" || die
	pytest -vv || die
}
