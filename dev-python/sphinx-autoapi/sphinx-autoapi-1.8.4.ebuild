# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A new approach to API documentation in Sphinx"
HOMEPAGE="https://sphinx-autoapi.readthedocs.io/"
SRC_URI="https://github.com/readthedocs/sphinx-autoapi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# pypi lacks docs/

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+python" # go javascript dotnet, currently not supported

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	python? ( dev-python/astroid[${PYTHON_USEDEP}] )
"

DOCS=( README.rst CHANGELOG.rst )

distutils_enable_tests pytest
distutils_enable_sphinx docs --no-autodoc
