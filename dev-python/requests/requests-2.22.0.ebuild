# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="http://python-requests.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="socks5 +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/certifi-2017.4.17[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]
	<dev-python/chardet-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	<dev-python/idna-2.9[${PYTHON_USEDEP}]
	<dev-python/urllib3-1.26[${PYTHON_USEDEP}]
	socks5? ( >=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}] )
	ssl? (
		>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-0.14[$(python_gen_usedep 'python*' pypy)]
	)
"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-httpbin[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			>=dev-python/PySocks-1.5.6[${PYTHON_USEDEP}]
		' python{2_7,3_{5,6,7}})
	)
"

PATCHES=(
	"${FILESDIR}"/requests-2.22.0-pytest-4.patch
)

src_prepare() {
	distutils-r1_src_prepare

	# strip tests that require some kind of network
	sed -e 's:test_connect_timeout:_&:' \
		-e 's:test_total_timeout_connect:_&:' \
		-i tests/test_requests.py || die
	# probably pyopenssl version dependent
	sed -e 's:test_https_warnings:_&:' \
		-i tests/test_requests.py || die
}

python_test() {
	# tests hang with pypy & pypy3
	[[ ${EPYTHON} == pypy* ]] && continue
	# TODO: reenable when deps are ready
	[[ ${EPYTHON} == python3_8 ]] && continue

	pytest -vv || die "Tests failed with ${EPYTHON}"
}
