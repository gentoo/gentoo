# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="WebOb"
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="WSGI request and response object"
HOMEPAGE="
	https://webob.org/
	https://github.com/Pylons/webob/
	https://pypi.org/project/WebOb/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/legacy-cgi-2.6[${PYTHON_USEDEP}]
	' 3.{13..14})
"

distutils_enable_sphinx docs 'dev-python/alabaster'
distutils_enable_tests pytest

python_test() {
	if [[ ${EPYTHON} == python3.14* ]] ; then
		EPYTEST_DESELECT+=(
			# https://github.com/Pylons/webob/issues/479
			tests/test_in_wsgiref.py::test_interrupted_request
		)
	fi

	epytest
}
