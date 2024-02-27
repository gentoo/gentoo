# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Tools for testing processes"
HOMEPAGE="
	https://github.com/ionelmc/python-process-tests/
	https://pypi.org/project/process-tests/
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

distutils_enable_tests pytest

python_test() {
	local -x PYTHONUNBUFFERED=yes
	epytest
}
