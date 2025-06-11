# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
inherit distutils-r1 pypi

DESCRIPTION="Fast, pure-Python full text indexing, search and spell checking library"
HOMEPAGE="
	https://pypi.org/project/Whoosh/
	https://github.com/mchaput/whoosh
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.4-tests-specify-utf8.patch
)

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO
	tests/test_automata.py::test_minimize_dfa
)

python_prepare_all() {
	# (backport from upstream)
	sed -i -e '/cmdclass/s:pytest:PyTest:' setup.py || die
	# fix old section name
	sed -i -e 's@\[pytest\]@[tool:pytest]@' setup.cfg || die

	distutils-r1_python_prepare_all
}
