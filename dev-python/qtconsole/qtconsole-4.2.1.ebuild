# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 virtualx

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="http://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-4.1.1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? (
		>=dev-python/ipython-4.0.0-r2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.1-r1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		|| (
			dev-python/pyside[${PYTHON_USEDEP},svg]
			dev-python/PyQt5[${PYTHON_USEDEP},svg,testlib]
			dev-python/PyQt4[${PYTHON_USEDEP},svg,testlib]
		)
	)
	|| (
		dev-python/pyside[${PYTHON_USEDEP},svg]
		dev-python/PyQt5[${PYTHON_USEDEP},svg]
		dev-python/PyQt4[${PYTHON_USEDEP},svg]
	)
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-13[${PYTHON_USEDEP}]
	"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# jupyter qtconsole --generate-config ... jupyter-qtconsole: cannot connect to X server
	# ERROR
	sed \
		-e 's:test_generate_config:_&:g' \
		-i qtconsole/tests/test_app.py || die
	virtx nosetests --verbosity=2 qtconsole
}

python_install_all() {
	use doc && HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
