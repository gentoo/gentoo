# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=faust-cchardet
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="High speed universal character encoding detector"
HOMEPAGE="
	https://github.com/faust-streaming/cChardet/
	https://pypi.org/project/faust-cchardet/
"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
