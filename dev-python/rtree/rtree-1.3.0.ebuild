# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN^}

inherit distutils-r1 pypi

DESCRIPTION="R-Tree spatial index for Python GIS"
HOMEPAGE="
	https://rtree.readthedocs.io/
	https://github.com/Toblerity/rtree/
	https://pypi.org/project/Rtree/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	sci-libs/libspatialindex
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source \
	dev-python/sphinx-issues
distutils_enable_tests pytest
