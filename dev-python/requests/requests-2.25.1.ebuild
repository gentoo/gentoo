# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="https://requests.readthedocs.io/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="socks5 +ssl"

RDEPEND="
	>=dev-python/certifi-2017.4.17[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]
	<dev-python/chardet-5[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	<dev-python/idna-3[${PYTHON_USEDEP}]
	<dev-python/urllib3-1.27[${PYTHON_USEDEP}]
	socks5? ( >=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}] )
	ssl? (
		>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
	)
"

BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# strip tests that require some kind of network
	sed -e 's:test_connect_timeout:_&:' \
		-e 's:test_total_timeout_connect:_&:' \
		-i tests/test_requests.py || die
	# probably pyopenssl version dependent
	sed -e 's:test_https_warnings:_&:' \
		-i tests/test_requests.py || die
	# doctests rely on networking
	sed -e 's:--doctest-modules::' \
		-i pytest.ini || die
}
