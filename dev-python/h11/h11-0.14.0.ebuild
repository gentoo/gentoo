# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A pure-Python implementation of HTTP/1.1 inspired by hyper-h2"
HOMEPAGE="
	https://h11.readthedocs.io/en/latest/
	https://github.com/python-hyper/h11/
	https://pypi.org/project/h11/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
