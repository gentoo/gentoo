# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="http://gunicorn.org https://pypi.python.org/pypi/gunicorn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples test"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/setproctitle[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS="README.rst"

python_prepare() {
	# these tests requires an already installed version of gunicorn
	rm tests/test_003-config.py

	sed -ie "s/..\/bin/\/usr\/bin\//" docs/Makefile || die

	distutils-r1_python_prepare
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples
	fi
}
