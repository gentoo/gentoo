# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="
	http://www.mypy-lang.org/
	https://github.com/python/mypy_extensions/"
SRC_URI="
	https://github.com/python/mypy_extensions/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# This test assumes we get a TypeError, but that is no longer true in 3.11
	"tests/testextensions.py::TypedDictTests::test_typeddict_errors"
)

python_test() {
	epytest tests/*
}
