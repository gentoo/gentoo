# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Easily capture stdout/stderr of the current process and subprocesses"
HOMEPAGE="https://capturer.readthedocs.org/ https://pypi.python.org/pypi/capturer https://github.com/xolox/python-capturer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

# Test fails only ebuild, but works manually
# Can't find out what it is
RESTRICT=test

python_test() {
	esetup.py test
}
