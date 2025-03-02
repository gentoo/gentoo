# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Passive checker for Python programs"
HOMEPAGE="
	https://github.com/PyCQA/pyflakes/
	https://pypi.org/project/pyflakes/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		pypy3)
			# regressions with pypy3.10
			# https://github.com/PyCQA/pyflakes/issues/779
			EPYTEST_DESELECT+=(
				pyflakes/test/test_api.py::CheckTests::test_eofSyntaxError
				pyflakes/test/test_api.py::CheckTests::test_misencodedFileUTF8
				pyflakes/test/test_api.py::CheckTests::test_multilineSyntaxError
			)
			;;
		python3.13)
			EPYTEST_DESELECT+=(
				# failing due to improved error message
				# https://github.com/PyCQA/pyflakes/issues/812
				pyflakes/test/test_api.py::IntegrationTests::test_errors_syntax
				pyflakes/test/test_api.py::TestMain::test_errors_syntax
			)
			;;
	esac

	local -X PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
