# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1

MY_P=mypy_extensions-${PV}
DESCRIPTION="Type system extensions for programs checked with mypy"
HOMEPAGE="
	https://www.mypy-lang.org/
	https://github.com/python/mypy_extensions/
"
SRC_URI="
	https://github.com/python/mypy_extensions/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		python3.14)
			EPYTEST_DESELECT+=(
				tests/testextensions.py::TypedDictTests::test_py36_class_syntax_usage
			)
			;;
	esac

	epytest tests/*.py
}
