# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="
	https://pythonpaste.readthedocs.io/en/latest/
	https://github.com/cdent/paste/
	https://pypi.org/project/Paste/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	!dev-python/namespace-paste
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_proxy.py
	)

	[[ ${EPYTHON} == python3.1[12] ]] && EPYTEST_DESELECT+=(
		# fails due to cgi deprecation warning
		tests/test_cgiapp.py::test_form
	)

	epytest
}
