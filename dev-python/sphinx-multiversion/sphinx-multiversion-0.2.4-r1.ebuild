# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Add support for multiple versions to sphinx"
HOMEPAGE="
	https://github.com/Holzhaus/sphinx-multiversion/
	https://pypi.org/project/sphinx-multiversion/
"
SRC_URI="
	https://github.com/Holzhaus/sphinx-multiversion/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

DEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/alabaster
