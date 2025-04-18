# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi

DESCRIPTION="Matplotlib Jupyter Extension"
HOMEPAGE="https://matplotlib.org"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/ipywidgets-7.6.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.4.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

src_prepare() {
	addpredict /usr/etc
	default
}

src_install() {
	distutils-r1_src_install
	mv "${D}"/usr/etc/ "${D}"/etc
}
