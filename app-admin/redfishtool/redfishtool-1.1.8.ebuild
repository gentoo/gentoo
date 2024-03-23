# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python package and command-line tool for accessing the Redfish API"
HOMEPAGE="https://github.com/DMTF/Redfishtool"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
