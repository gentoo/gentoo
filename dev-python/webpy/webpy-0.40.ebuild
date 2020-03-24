# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A web framework for python that is as simple as it is powerful"
HOMEPAGE="
	https://www.webpy.org
	https://github.com/webpy/webpy
"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/cheroot[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-python/pytest-4.6.2[${PYTHON_USEDEP}]
	)
"
#		dev-python/dbutils[${PYTHON_USEDEP}]
#		>=dev-python/mysql-connector-python-8.0.19[${PYTHON_USEDEP}]
#		dev-python/pymysql[${PYTHON_USEDEP}]
#		>=dev-python/psycopg-2.8.4[${PYTHON_USEDEP}]

distutils_enable_tests pytest
distutils_enable_sphinx docs

src_prepare() {
	#tests require postgresql and mysql running
	rm tests/test_db.py
	default
}
