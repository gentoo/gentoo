# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit_scm
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Backport of PEP 654 (exception groups)"
HOMEPAGE="
	https://github.com/agronholm/exceptiongroup/
	https://pypi.org/project/exceptiongroup/
"

LICENSE="MIT PSF-2.4"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3.11)
			# exception message mismatch
			# https://github.com/agronholm/exceptiongroup/issues/141
			EPYTEST_DESELECT+=(
				tests/test_exceptions.py::BadConstructorArgs::test_bad_EG_construction__too_few_args
				tests/test_exceptions.py::BadConstructorArgs::test_bad_EG_construction__too_many_args
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
