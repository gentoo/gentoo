# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="A modern CSS selector implementation for BeautifulSoup"
HOMEPAGE="https://github.com/facelessuser/soupsieve
	https://pypi.python.org/pypi/soupsieve"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]' -2)
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/beautifulsoup[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/lxml[${PYTHON_USEDEP}]' python2_7 'python3*')
		dev-python/html5lib[${PYTHON_USEDEP}]
	)
"

RESTRICT+=" !test? ( test )"

distutils_enable_tests pytest
