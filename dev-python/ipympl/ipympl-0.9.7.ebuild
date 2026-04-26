# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Matplotlib extension for Jupyter"
HOMEPAGE="
	https://matplotlib.org/ipympl
	https://github.com/matplotlib/ipympl
	https://pypi.org/project/ipympl
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipython-genutils[${PYTHON_USEDEP}]
	>=dev-python/ipywidgets-7.6.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.4.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	addpredict /usr/etc
	default
}

src_install() {
	distutils-r1_src_install
	mv "${D}"/usr/etc/ "${D}"/etc || die
}
