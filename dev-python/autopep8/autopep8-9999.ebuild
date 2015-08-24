# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1 git-2

DESCRIPTION="Automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="https://github.com/hhatto/autopep8 https://pypi.python.org/pypi/autopep8"
SRC_URI=""
EGIT_REPO_URI="git://github.com/hhatto/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=dev-python/pep8-1.5.7[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	test? ( >=dev-python/pydiff-0.1.2[${PYTHON_USEDEP}] )"

python_test() {
	"${PYTHON}" setup.py test || die
}
