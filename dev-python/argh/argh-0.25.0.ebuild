# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A simple argparse wrapper"
HOMEPAGE="http://packages.python.org/argh/"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="LGPL-3"
IUSE="test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

python_test() {
	# setup.py tries to install argparse for some reason...
	py.test || die "Tests fail with ${EPYTHON}"
}
