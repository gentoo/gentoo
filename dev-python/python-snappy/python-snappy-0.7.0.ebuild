# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python library for the snappy compression library from Google"
HOMEPAGE="
	https://github.com/intake/python-snappy/
	https://pypi.org/project/python-snappy/
"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/cramjam-2.6.0[${PYTHON_USEDEP}]
	dev-python/crc32c[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
