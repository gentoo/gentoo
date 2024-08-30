# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python library for the snappy compression library from Google"
HOMEPAGE="
	https://github.com/intake/python-snappy/
	https://pypi.org/project/python-snappy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/cramjam-2.6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
