# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="https://ipywidgets.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 hppa ~ia64 ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/ipykernel-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/ipython_genutils-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/nbformat-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-3.5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-7.6.3-py310.patch"
)
