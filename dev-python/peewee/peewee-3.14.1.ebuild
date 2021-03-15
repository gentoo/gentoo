# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Small Python ORM"
HOMEPAGE="https://github.com/coleifer/peewee/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? ( dev-python/psycopg[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx docs

python_test() {
	"${EPYTHON}" ./runtests.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && DOCS=( examples/ )
	distutils-r1_python_install_all
}
