# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python library for Intel HEX files manipulations"
HOMEPAGE="
	https://github.com/python-intelhex/intelhex/
	https://pypi.org/project/intelhex/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~riscv ~x86"

distutils_enable_tests unittest
