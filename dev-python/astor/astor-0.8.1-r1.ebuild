# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Read/rewrite/write Python ASTs"
HOMEPAGE="https://pypi.org/project/astor/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-tests-bigint.patch
)

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_rtrip.py
)
