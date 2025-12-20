# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Asynchronous API for ZMQ using AnyIO"
HOMEPAGE="
	https://github.com/QuantStack/zmq-anyio/
	https://pypi.org/project/zmq-anyio/
"
# https://github.com/QuantStack/zmq-anyio/issues/34
SRC_URI="
	https://github.com/QuantStack/zmq-anyio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-4.10.0[${PYTHON_USEDEP}]
	<dev-python/anyioutils-0.8[${PYTHON_USEDEP}]
	>=dev-python/anyioutils-0.7.1[${PYTHON_USEDEP}]
	<dev-python/pyzmq-28[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-26.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/trio-0.27.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio pytest-timeout  )
distutils_enable_tests pytest
