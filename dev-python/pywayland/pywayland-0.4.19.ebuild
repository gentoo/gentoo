# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Python bindings for the libwayland library"
HOMEPAGE="
	https://pywayland.readthedocs.io/en/latest/
	https://github.com/flacjacket/pywayland
	https://pypi.org/project/pywayland/
"
SRC_URI="
	https://github.com/flacjacket/pywayland/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-libs/wayland
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-util/wayland-scanner
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	# https://github.com/flacjacket/pywayland/
	rm pywayland/_ffi.* || die
}

python_test() {
	local -x XDG_RUNTIME_DIR=${T}

	rm -rf pywayland || die
	epytest
}
