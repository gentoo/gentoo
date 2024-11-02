# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Streaming-capable SipHash-1-3 and SipHash-2-4 Implementation"
HOMEPAGE="
	https://github.com/dnicolodi/python-siphash24/
	https://pypi.org/project/siphash24/
"

LICENSE="|| ( Apache-2.0 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~amd64 arm64 ~riscv"

DEPEND="
	dev-libs/c-siphash
"
BDEPEND="
	>=dev-python/cython-3.0.2[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
