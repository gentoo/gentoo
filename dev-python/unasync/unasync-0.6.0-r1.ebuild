# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="The async transformation code"
HOMEPAGE="
	https://github.com/python-trio/unasync/
	https://pypi.org/project/unasync/
"
SRC_URI="
	https://github.com/python-trio/unasync/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_sphinx docs/source \
	dev-python/sphinxcontrib-trio \
	dev-python/sphinx-rtd-theme

distutils_enable_tests pytest

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tokenize-rt[${PYTHON_USEDEP}]
"
