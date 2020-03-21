# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN="Flask-Admin"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple and extensible admin interface framework for Flask"
HOMEPAGE="https://pypi.org/project/Flask-Admin/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/wtforms[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		dev-python/peewee[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},jpeg,tiff]
	)"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests nose

src_prepare() {
	default
	# Tests only work with PyMongo 2
	rm -rf flask_admin/tests/pymongo || die
	# Tests require PostgreSQL server
	rm -rf flask_admin/tests/geoa || die
	rm -rf flask_admin/tests/sqla || die
}
