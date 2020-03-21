# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Small Python ORM"
HOMEPAGE="https://github.com/coleifer/peewee/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

# tests not included in PyPI tarball
RESTRICT="test"

DEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs

python_install_all() {
	use examples && DOCS=( examples/ )
	distutils-r1_python_install_all
}
