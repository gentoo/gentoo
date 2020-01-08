# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

# incomplete tarball
RESTRICT="test"

DESCRIPTION="A compiler written in Python for the LESS language"
HOMEPAGE="https://pypi.org/project/lesscpy/"
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
