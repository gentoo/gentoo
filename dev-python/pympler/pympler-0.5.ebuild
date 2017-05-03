# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

MY_PN="Pympler"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Memory profiling for Python applications"
HOMEPAGE="https://code.google.com/p/pympler/ https://pypi.python.org/pypi/Pympler https://github.com/pympler/pympler"
SRC_URI="https://github.com/pympler/pympler/archive/${PV}.tar.gz -> ${P}.tar.gz"
# The PyPi tarball is missing the documentation
#SRC_URI="mirror://pypi/P/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="dev-python/bottle[${PYTHON_USEDEP}]"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND} )"

python_compile_all() {
	if use doc; then
		python_setup
		sphinx-build -b html doc/{source,html} || die
	fi
}

python_test() {
	esetup.py try
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
