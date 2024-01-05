# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Passive checker for Python programs"
HOMEPAGE="
	https://github.com/PyCQA/pyflakes/
	https://pypi.org/project/pyflakes/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	if [[ ${EPYTHON} == pypy3 ]]; then
		# regressions with pypy3.10
		# https://github.com/PyCQA/pyflakes/issues/779
		EPYTEST_DESELECT+=(
			pyflakes/test/test_api.py::CheckTests::test_eofSyntaxError
			pyflakes/test/test_api.py::CheckTests::test_misencodedFileUTF8
			pyflakes/test/test_api.py::CheckTests::test_multilineSyntaxError
		)
	fi

	epytest
}
