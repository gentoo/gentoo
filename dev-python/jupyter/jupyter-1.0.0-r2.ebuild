# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Jupyter metapackage. Install all the Jupyter components in one go"
HOMEPAGE="https://jupyter.org"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://patch-diff.githubusercontent.com/raw/jupyter/jupyter/pull/198.patch -> ${P}-file-colision.patch
	"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/qtconsole[${PYTHON_USEDEP}]
	dev-python/jupyter_console[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/ipywidgets[${PYTHON_USEDEP}]"
PDEPEND=">=dev-python/jupyter_core-4.2.0[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

PATCHES=( "${DISTDIR}"/${P}-file-colision.patch )

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}
