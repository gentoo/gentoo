# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="Python library to create spreadsheet files compatible with Excel"
HOMEPAGE="https://pypi.python.org/pypi/xlwt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
		dev-python/pkginfo[${PYTHON_USEDEP}]
	)
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

# Prevent d'loading in the doc build
PATCHES=( "${FILESDIR}"/docbuild.patch )

python_prepare_all() {
	# Don't install documentation and examples in site-packages directories.
	sed -e "/package_data/d" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests tests || die "tests failed under ${EPYTHON}}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
