# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 virtualx

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="http://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-4.1.1[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? (
		>=dev-python/sphinx-1.3.1-r1[${PYTHON_USEDEP}]
	)
	dev-python/PyQt5[${PYTHON_USEDEP},svg]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-13[${PYTHON_USEDEP}]
	"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}
