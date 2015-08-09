# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Logging framework handler that tracks when messages above a certain level have been logged"
HOMEPAGE="http://pypi.python.org/pypi/errorhandler"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE="doc"

LICENSE="MIT"
SLOT="0"

RDEPEND=""
DEPEND="
	dev-python/pkginfo[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/docs.patch
)

python_prepare_all() {
	sed -e 's:../bin/sphinx-build:/usr/bin/sphinx-build:' -i docs/Makefile || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" -c "import errorhandler.tests as et, unittest; \
		unittest.TextTestRunner().run(et.test_suite())" \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
