# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Get CPU info with pure Python 2 & 3"
HOMEPAGE="
	https://github.com/workhorsy/py-cpuinfo/
	https://pypi.org/project/py-cpuinfo/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ia64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest
