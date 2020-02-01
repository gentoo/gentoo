# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DOCS=( README.rst LICENSE.rst CHANGES.rst )

DESCRIPTION="Default Sphinx configuration for astropy and specific extensions"
HOMEPAGE="https://github.com/astropy/sphinx-astropy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/sphinx-1.7[${PYTHON_USEDEP}]
	dev-python/astropy-sphinx-theme
	dev-python/numpydoc
	dev-python/sphinx-automodapi
	dev-python/sphinx-gallery
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
