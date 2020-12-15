# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A double-entry accounting system that uses text files as input"
HOMEPAGE="https://github.com/beancount/beancount"
SRC_URI="https://github.com/beancount/beancount/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.3-disable-network-tests.patch"
	"${FILESDIR}/${PN}-2.3.3-disable-tmp-access-tests.patch"
	"${FILESDIR}/${PN}-2.3.3-disable-install-test.patch"
)

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/beautifulsoup-4[${PYTHON_USEDEP}]
		>=dev-python/bottle-0.12[${PYTHON_USEDEP}]
		>=dev-python/google-api-python-client-1.8.2[${PYTHON_USEDEP}]
		>=dev-python/httplib2-0.10[${PYTHON_USEDEP}]
		>=dev-python/lxml-3.0[${PYTHON_USEDEP}]
		>=dev-python/oauth2client-4.0[${PYTHON_USEDEP}]
		>=dev-python/ply-3.4[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/python-magic-0.4.12[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	')
"

BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			>=dev-python/pytest-5.4.2[${PYTHON_USEDEP}]
		')
	)
"

python_test(){
	esetup.py build_ext -i
	make ctest
	make test
}
