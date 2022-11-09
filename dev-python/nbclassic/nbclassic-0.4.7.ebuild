# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=jupyter

inherit distutils-r1 xdg-utils

DESCRIPTION="Jupyter Notebook as a Jupyter Server Extension"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/nbclassic/
	https://pypi.org/project/nbclassic/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/jupyter_server-1.17.0[${PYTHON_USEDEP}]
	<dev-python/notebook-7[${PYTHON_USEDEP}]
	>=dev-python/notebook_shim-0.1.0[${PYTHON_USEDEP}]
"

# pytest-console-scripts seem unused
BDEPEND="
	test? (
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
	)
	doc? (
		virtual/pandoc
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
	dev-python/sphinx_rtd_theme \
	dev-python/nbsphinx \
	dev-python/sphinxcontrib-github-alt \
	dev-python/myst_parser \
	dev-python/ipython_genutils

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}

python_install_all() {
	distutils-r1_python_install_all
	# move /usr/etc stuff to /etc
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
