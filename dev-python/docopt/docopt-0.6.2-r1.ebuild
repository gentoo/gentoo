# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Pythonic argument parser, that will make you smile"
HOMEPAGE="https://pypi.python.org/pypi/docopt https://github.com/docopt/docopt"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://github.com/docopt/docopt/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

# not implemented in this version, git already has it
RESTRICT=test

python_test() {
	esetup.py test
}
