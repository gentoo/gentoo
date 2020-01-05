# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

#RESTRICT="test" # we're still missing some of the dependencies

MY_PN="Flask-Admin"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple and extensible admin interface framework for Flask"
HOMEPAGE="https://pypi.org/project/Flask-Admin/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/flask-0.7[${PYTHON_USEDEP}]
	dev-python/wtforms[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/flask-wtf[${PYTHON_USEDEP}]
		dev-python/peewee[${PYTHON_USEDEP}]
		dev-python/wtf-peewee[${PYTHON_USEDEP}]
		dev-python/flask-pymongo[${PYTHON_USEDEP}]
		dev-python/flask-mongoengine[${PYTHON_USEDEP}]
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/flask-babelex[${PYTHON_USEDEP}]
		sci-libs/Shapely[${PYTHON_USEDEP}]
		dev-python/geoalchemy2[${PYTHON_USEDEP}]
		>=dev-python/pillow-2.9[${PYTHON_USEDEP},jpeg(+)]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed \
		-e 's:find_packages():find_packages(exclude=["*.examples", "*.examples.*", "examples.*", "examples"]):g' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
