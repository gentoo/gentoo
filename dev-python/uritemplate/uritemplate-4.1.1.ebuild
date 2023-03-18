# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of RFC6570, URI Template"
HOMEPAGE="
	https://uritemplate.readthedocs.io/en/latest/
	https://pypi.org/project/uritemplate/
	https://github.com/python-hyper/uritemplate/
"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
