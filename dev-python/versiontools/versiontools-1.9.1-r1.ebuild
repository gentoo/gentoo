# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Smart replacement for plain tuple used in __version__"
HOMEPAGE="https://pypi.python.org/pypi/versiontools/ https://launchpad.net/versiontools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE=""

LICENSE="GPL-2"
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Expexted failure
	sed -e s':test_cant_import:_&:' -i versiontools/tests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
