# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="File transport adapter for Requests"
HOMEPAGE="https://pypi.org/project/requests-file/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
