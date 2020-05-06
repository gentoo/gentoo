# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Fork of MySQL-python"
HOMEPAGE="https://pypi.org/project/mysqlclient/ https://github.com/PyMySQL/mysqlclient-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	!dev-python/mysql-python
	dev-db/mysql-connector-c:0="
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

DOCS=( README.md doc/{FAQ,MySQLdb}.rst )

python_compile_all() {
	use doc && sphinx-build -b html doc doc/_build/
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/. )
	distutils-r1_python_install_all
}
