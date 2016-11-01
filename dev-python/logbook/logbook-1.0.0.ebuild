# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy )

inherit distutils-r1

DESCRIPTION="A logging replacement for Python"
HOMEPAGE="http://packages.python.org/Logbook/ https://pypi.python.org/pypi/Logbook"
SRC_URI="https://github.com/mitsuhiko/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
DISTUTILS_IN_SOURCE_BUILD=1

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	doc? ( >=dev-python/sphinx-1.1.3-r3[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/redis-py[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.4.2-objectsinv.patch )

python_prepare_all() {
	# Delete test file requiring local connection to redis server
	rm tests/test_queues.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
