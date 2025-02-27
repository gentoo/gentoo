# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )
inherit distutils-r1

MY_PN=${PN//-/_}
MY_PN=${MY_PN/_/-}

DESCRIPTION="Exit pytest test session with custom exit code in different scenarios"
HOMEPAGE="
	https://pypi.org/project/pytest-custom-exit-code/
	https://github.com/yashtodi94/pytest-custom_exit_code
"

SRC_URI="https://github.com/yashtodi94/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-python/pytest-7.0.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

distutils_enable_tests pytest

python_test() {
	epytest tests
}
