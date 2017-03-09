# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Improved version of the old pydot project"
HOMEPAGE="http://pydotplus.readthedocs.org/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? (
#		dev-python/flake8[${PYTHON_USEDEP}]
#		dev-python/pytest[${PYTHON_USEDEP}]
#		dev-python/pytest-cov[${PYTHON_USEDEP}]
#		dev-python/sphinx[${PYTHON_USEDEP}]
#		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
#		dev-python/tox[${PYTHON_USEDEP}]
#		)
RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	"

#test phase curently disabled, waiting on upstream to include
#the required files:
#https://github.com/carlos-jenkins/pydotplus/issues/12
#python_test() {
#	${EPYTHON} -m unittest discover || die
#	tox
#}
