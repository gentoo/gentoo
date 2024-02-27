# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="
	https://github.com/novnc/websockify/
	https://pypi.org/project/websockify/
"
SRC_URI="
	https://github.com/novnc/websockify/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/jwcrypto[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO: incompatible with current jwcrypto? (not a regression)
	tests/test_token_plugins.py::JWSTokenTestCase::test_asymmetric_jwe_token_plugin
)

python_install_all() {
	doman docs/${PN}.1
	distutils-r1_python_install_all
}
