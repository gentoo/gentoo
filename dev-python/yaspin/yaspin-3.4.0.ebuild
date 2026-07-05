# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry-core
PYTHON_COMPAT=( python3_{12..15} )
PYPI_VERIFY_REPO=https://github.com/pavdmyt/yaspin

inherit distutils-r1 pypi

DESCRIPTION="Yet Another Terminal Spinner"
HOMEPAGE="
	https://github.com/pavdmyt/yaspin
	https://pypi.org/project/yaspin/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=dev-python/termcolor-3*[${PYTHON_USEDEP}]
	>=dev-python/termcolor-3.2[${PYTHON_USEDEP}]
"

EPYTEST_XDIST=1
EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest
