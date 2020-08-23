# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="A terminal-based console frontend for Jupyter kernels"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-3.1.0[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]"
# util-linux provides script(1)
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		sys-apps/util-linux
	)"

distutils_enable_sphinx docs \
	dev-python/sphinxcontrib-github-alt dev-python/sphinx_rtd_theme
distutils_enable_tests nose

PATCHES=(
	"${FILESDIR}"/${P}-py39.patch
	"${FILESDIR}"/${P}-increase-test-timeout.patch
)

python_prepare_all() {
	# use setuptools unconditionally
	sed -i -e 's:distutils\.core:setuptools:' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	script -eqc "nosetests -v" || die
}
