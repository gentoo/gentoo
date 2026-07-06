# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Character encoding aliases for legacy web content"
HOMEPAGE="
	https://github.com/gsnedders/python-webencodings/
	https://pypi.org/project/webencodings/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest -o 'python_files=test*.py'
}
