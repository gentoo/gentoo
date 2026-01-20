# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A fast, spec compliant Python 3.13+ tokenizer that runs on older Pythons"
HOMEPAGE="
	https://github.com/tusharsadhwani/pytokens/
	https://pypi.org/project/pytokens/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	local -x PYTOKENS_USE_MYPYC=0
}

python_test() {
	epytest -o addopts=
}
