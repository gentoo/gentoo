# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Small Python ORM"
HOMEPAGE="
	https://github.com/coleifer/peewee/
	https://pypi.org/project/peewee/
"
SRC_URI="
	https://github.com/coleifer/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs

python_test() {
	"${EPYTHON}" runtests.py -v 2 || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && DOCS=( examples/ )
	distutils-r1_python_install_all
}
