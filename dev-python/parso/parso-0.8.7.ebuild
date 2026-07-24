# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="A python parser that supports error recovery and round-trip parsing"
HOMEPAGE="
	https://github.com/davidhalter/parso/
	https://pypi.org/project/parso/
"
SRC_URI="
	https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

distutils_enable_sphinx docs

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.15*)
			EPYTEST_DESELECT+=(
				# minor exception message mismatch
				'test/test_python_errors.py::test_python_exception_matches[def f(x, x): pass]'
				'test/test_python_errors.py::test_python_exception_matches[def x(*): pass]'
				# now valid in py3.15
				'test/test_python_errors.py::test_python_exception_matches[[*[] for a in [1]]]'
				'test/test_python_errors.py::test_python_exception_matches[{**{} for a in [1]}]'
			)
			;;
	esac

	epytest
}
