# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 xdg-utils

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
KEYWORDS="amd64 ~riscv ~x86"

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
	dev-util/wayland-scanner
"

distutils_enable_tests pytest

python_prepare_all() {
	# Needed for tests (XDG_RUNTIME_DIR)
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

python_test() {
	# No die deliberately as sometimes it doesn't exist
	rm -rf pywayland || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
