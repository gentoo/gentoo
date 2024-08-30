# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Safely evaluate AST nodes without side effects"
HOMEPAGE="
	https://github.com/alexmojaki/pure_eval/
	https://pypi.org/project/pure-eval/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/alexmojaki/pure_eval/commit/42e8a1f4a41b60c51619868f543e7b3ee82ac42f
	# https://github.com/alexmojaki/pure_eval/pull/18
	"${FILESDIR}/${P}-py313.patch"
)

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# https://github.com/alexmojaki/pure_eval/issues/15
				tests/test_getattr_static.py::TestGetattrStatic::test_custom_object_dict
				tests/test_utils.py::test_safe_name_samples
			)
			;;
	esac

	epytest
}
