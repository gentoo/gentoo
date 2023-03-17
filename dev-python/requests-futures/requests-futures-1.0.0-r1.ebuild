# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous Python HTTP for Humans"
HOMEPAGE="https://github.com/ross/requests-futures"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND=">=dev-python/requests-1.2.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# known failures by upstream
	# https://github.com/ross/requests-futures/issues/94
	test_requests_futures.py::RequestsTestCase::test_redirect
	test_requests_futures.py::RequestsProcessPoolTestCase::test_futures_existing_session
	test_requests_futures.py::RequestsProcessPoolTestCase::test_futures_session
)
