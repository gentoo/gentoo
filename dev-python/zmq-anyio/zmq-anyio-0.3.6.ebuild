# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
# PyPy: https://github.com/davidbrochart/zmq-anyio/issues/22
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous API for ZMQ using AnyIO"
HOMEPAGE="
	https://github.com/davidbrochart/zmq-anyio/
	https://pypi.org/project/zmq-anyio/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.8.0[${PYTHON_USEDEP}]
	<dev-python/anyioutils-0.8[${PYTHON_USEDEP}]
	>=dev-python/anyioutils-0.7.1[${PYTHON_USEDEP}]
	<dev-python/pyzmq-27[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-26.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/trio-0.27.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p anyio
}
