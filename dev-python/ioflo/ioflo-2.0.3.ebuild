# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Automated Reasoning Engine and Flow Based Programming Framework"
HOMEPAGE="
	https://github.com/ioflo/ioflo/
	https://pypi.org/project/ioflo/
"
SRC_URI="
	https://github.com/ioflo/ioflo/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# some random mismatch that breaks other tests by leaving the server
	# hanging
	ioflo/aio/http/test/test_serving.py::BasicTestCase::testValetServiceBottle
	# unhappy about SSL-something
	ioflo/aio/tcp/test/test_tcping.py::BasicTestCase::testTLSConnectionVerifyBothTLSv1
	# requires a fancy network interface
	ioflo/aio/udp/test/test_udping.py::BasicTestCase::testBroadcast
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i -e '/setuptools_git/d' setup.py || die
}
