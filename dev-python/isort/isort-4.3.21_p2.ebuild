# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PV="${PV//_p/-}"

DESCRIPTION="A python utility/library to sort imports"
HOMEPAGE="https://pypi.org/project/isort/"
SRC_URI="https://github.com/timothycrosley/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~sparc ~x86"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pipfile[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]' -2)
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/isort-4.3.21_p1-tests.patch"
)

distutils_enable_tests pytest
