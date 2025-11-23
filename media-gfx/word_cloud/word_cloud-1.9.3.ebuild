# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11,12,13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="A little word cloud generator in Python"
HOMEPAGE="https://amueller.github.io/word_cloud/"
SRC_URI="https://github.com/amueller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  #808150

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-fonts/droid"

BDEPEND="dev-python/cython
	dev-python/setuptools-scm"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_install() {
	distutils-r1_python_install
	local sitedir=$(python_get_sitedir)
	insinto "${sitedir#${EPREFIX}}"/${PN/_}
	doins ${PN/_}/stopwords
}
