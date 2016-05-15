# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1

DESCRIPTION="Tiny, document oriented database optimized for your happiness :)"
HOMEPAGE="https://github.com/msiemens/tinydb http://pypi.python.org/pypi/tinydb"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed \
		-e "s:find_packages():find_packages(exclude=['tests']):g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v || die
}
