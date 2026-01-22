# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Pure-Python gRPC implementation for asyncio"
HOMEPAGE="
	https://github.com/vmagamedov/grpclib/
	https://pypi.org/project/grpclib/
"
# no tests in sdist, as of 0.4.7
SRC_URI="
	https://github.com/vmagamedov/grpclib/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

# setup.txt + requirements/runtime.in
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/googleapis-common-protos[${PYTHON_USEDEP}]
	dev-python/h2[${PYTHON_USEDEP}]
	dev-python/multidict[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/async-timeout[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( faker pytest-asyncio )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# flaky leak checks
	tests/test_memory.py
)
