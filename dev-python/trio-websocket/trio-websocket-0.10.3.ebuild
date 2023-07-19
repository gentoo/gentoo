# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..11} )

inherit distutils-r1

DESCRIPTION="WebSocket client and server implementation for Python Trio"
HOMEPAGE="
	https://github.com/HyperionGray/trio-websocket/
	https://pypi.org/project/trio-websocket/
"
SRC_URI="
	https://github.com/HyperionGray/trio-websocket/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/exceptiongroup[${PYTHON_USEDEP}]
	>=dev-python/trio-0.11[${PYTHON_USEDEP}]
	>=dev-python/wsproto-0.14[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-trio-0.5.0[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p trio
}
