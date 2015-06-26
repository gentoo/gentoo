# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/lesscpy/lesscpy-0.10.2.ebuild,v 1.1 2015/06/26 04:46:18 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A compiler written in Python for the LESS language"
HOMEPAGE="https://pypi.python.org/pypi/lesscpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/ply[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	# https://github.com/lesscpy/lesscpy/issues/74
	esetup.py test
	# This is equally effective
	# nosetests -v || die "tests failed under ${EPYTHON}"
}
