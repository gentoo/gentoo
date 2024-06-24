# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="
	https://github.com/jd/tenacity/
	https://pypi.org/project/tenacity/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			>=dev-python/tornado-6.4-r1[${PYTHON_USEDEP}]
			dev-python/typeguard[${PYTHON_USEDEP}]
		' 3.{10..12})
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=()
	if ! has_version ">=dev-python/tornado-6.4-r1[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/test_tornado.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
