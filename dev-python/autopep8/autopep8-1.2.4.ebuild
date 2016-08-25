# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="https://github.com/hhatto/autopep8 https://pypi.python.org/pypi/autopep8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/pep8-1.5.7[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	test? (	>=dev-python/pydiff-0.1.2[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent UnicodeDecodeError with LANG=C
	sed -e "/é/d" -i MANIFEST.in || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
