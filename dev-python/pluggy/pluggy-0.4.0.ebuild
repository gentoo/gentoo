# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="plugin and hook calling mechanisms for python"
HOMEPAGE=" http://pypi.python.org/pypi/pluggy"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test -v -v || die
}
