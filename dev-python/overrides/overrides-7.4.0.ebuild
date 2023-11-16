# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A decorator to automatically detect mismatch when overriding a method."
HOMEPAGE="
	https://pypi.org/project/overrides/
	https://github.com/mkorpela/overrides/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.12)
			EPYTEST_DESELECT+=(
				# https://github.com/mkorpela/overrides/issues/117
				tests/test_enforce__py38.py::EnforceTests::test_enforcing_when_incompatible
			)
			;;
		pypy3)
			EPYTEST_DESELECT+=(
				# https://github.com/mkorpela/overrides/issues/118
				tests/test_overrides.py::OverridesTests::test_overrides_builtin_method_{,in}correct_signature
			)
			;;
	esac

	epytest
}
