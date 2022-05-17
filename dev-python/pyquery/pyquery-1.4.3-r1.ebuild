# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1 optfeature

DESCRIPTION="A jQuery-like library for python"
HOMEPAGE="
	https://github.com/gawel/pyquery/
	https://pypi.org/project/pyquery/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/lxml-2.1[${PYTHON_USEDEP}]
	>dev-python/cssselect-0.7.9[${PYTHON_USEDEP}]
	>=dev-python/webob-1.1.9[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/pyquery-1.4.1-network-tests.patch"
	"${FILESDIR}/pyquery-1.4.1-tests-pypy.patch"
)

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "Support for BeautifulSoup3 as a parser backend" dev-python/beautifulsoup4
}
