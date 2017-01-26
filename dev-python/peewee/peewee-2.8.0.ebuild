# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="sqlite(+)"

inherit distutils-r1

DESCRIPTION="Small python ORM"
HOMEPAGE="https://github.com/coleifer/peewee/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
# Req'd to ensure a unique tmp.db for each python impl running the testsuite.
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -i -e "s#test_suite='tests',##g;" ./setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# Testsuite run using runtests.py does not require deps listed in previous ebuild
	"${PYTHON}" ./runtests.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && DOCS=( examples/ )
	distutils-r1_python_install_all
}
