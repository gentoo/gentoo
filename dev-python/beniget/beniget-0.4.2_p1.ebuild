# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Extract semantic information about static Python code"
HOMEPAGE="
	https://pypi.org/project/beniget/
	https://github.com/serge-sans-paille/beniget/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/gast-0.5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
