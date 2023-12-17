# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python library for Intel HEX files manipulations"
HOMEPAGE="
	https://github.com/python-intelhex/intelhex/
	https://pypi.org/project/intelhex/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~riscv ~x86"

distutils_enable_tests unittest
