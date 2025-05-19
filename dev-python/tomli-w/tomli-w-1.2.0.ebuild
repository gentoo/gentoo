# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1

DESCRIPTION="A lil' TOML writer"
HOMEPAGE="
	https://pypi.org/project/tomli-w/
	https://github.com/hukkin/tomli-w/
"
SRC_URI="
	https://github.com/hukkin/tomli-w/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/tomli[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest tests
}
