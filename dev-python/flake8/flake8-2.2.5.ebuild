# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://bitbucket.org/tarek/flake8 https://pypi.python.org/pypi/flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
LICENSE="MIT"
SLOT="0"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND=">=dev-python/pyflakes-0.7.3[${PYTHON_USEDEP}]
	>=dev-python/pep8-1.5.7[${PYTHON_USEDEP}]"
PDEPEND=">=dev-python/mccabe-0.2.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${PDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# This tests requires / assumes this version is already installed.
	sed -e 's:test_register_extensions:_&:' -i flake8/tests/test_engine.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
