# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="threads(+)"

inherit cmake distutils-r1 toolchain-funcs

DESCRIPTION="A self-contained cryptographic library for Python"
HOMEPAGE="
	https://www.pycryptodome.org/
	https://github.com/Legrandin/pycryptodome/
	https://pypi.org/project/pycryptodome/
"
SRC_URI="
	https://github.com/Legrandin/pycryptodome/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2 MIT Unlicense"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

DEPEND="
	dev-libs/gmp:=
"
BDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	${BDEPEND}
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

CMAKE_USE_DIR=${S}/src/test

src_prepare() {
	cmake_src_prepare
	distutils-r1_src_prepare

	# force sanitizer detection to fail, they break tests x_x
	sed -i -e 's:-fsanitize=[a-z]*::g' src/test/CMakeLists.txt || die
}

check_x86_opt() {
	local macro=${1}

	if { use amd64 || use x86; } &&
		tc-cpp-is-true "defined(${macro})" ${CFLAGS} ${CPPFLAGS}
	then
		echo ON
	else
		echo OFF
	fi
}

src_test() {
	local mycmakeargs=(
		# TODO: grab these off CFLAGS, they enable extra tests
		-DAESNI="$(check_x86_opt __AES__)"
		-DSSE="$(check_x86_opt __SSSE3__)"

		-DVALGRIND=FALSE
	)

	cmake_src_configure
	cmake_src_compile
	cmake_src_test

	distutils-r1_src_test
}

python_test() {
	local -x PYTHONPATH=${S}/test_vectors:${PYTHONPATH}
	epytest --pyargs Crypto

	# TODO: run cmake tests from src/test?
}
