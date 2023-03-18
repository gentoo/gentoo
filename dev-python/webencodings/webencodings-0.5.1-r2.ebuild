# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Character encoding aliases for legacy web content"
HOMEPAGE="
	https://github.com/gsnedders/python-webencodings/
	https://pypi.org/project/webencodings/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

distutils_enable_tests pytest

python_prepare_all() {
	cat >> setup.cfg <<- EOF || die
		[tool:pytest]
		python_files=test*.py
	EOF
	distutils-r1_python_prepare_all
}
