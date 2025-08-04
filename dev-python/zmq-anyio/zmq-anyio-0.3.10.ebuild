# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous API for ZMQ using AnyIO"
HOMEPAGE="
	https://github.com/QuantStack/zmq-anyio/
	https://pypi.org/project/zmq-anyio/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test-rust"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.8.0[${PYTHON_USEDEP}]
	<dev-python/anyioutils-0.8[${PYTHON_USEDEP}]
	>=dev-python/anyioutils-0.7.1[${PYTHON_USEDEP}]
	<dev-python/pyzmq-28[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-26.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		test-rust? (
			>=dev-python/trio-0.27.0[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_PLUGINS=( anyio )
distutils_enable_tests pytest

python_test() {
	local args=()
	if ! has_version "dev-python/trio[${PYTHON_USEDEP}]"; then
		args+=( -k "not trio" )
	fi

	epytest "${args[@]}"
}
