# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Patch asyncio to allow nested event loops"
HOMEPAGE="
	https://github.com/erdewit/nest_asyncio/
	https://pypi.org/project/nest-asyncio/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.14)
			EPYTEST_DESELECT+=(
				tests/nest_test.py::NestTest::test_timeout
			)
			;;
	esac

	epytest
}
