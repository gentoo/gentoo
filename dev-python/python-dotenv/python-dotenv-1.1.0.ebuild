# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Manage .env files"
HOMEPAGE="
	https://github.com/theskumar/python-dotenv/
	https://pypi.org/project/python-dotenv/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		>=dev-python/click-5[${PYTHON_USEDEP}]
		>=dev-python/sh-2[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# test issue with click-8.2.0
		# https://github.com/theskumar/python-dotenv/issues/560
		tests/test_cli.py::test_get_non_existent_file
		tests/test_cli.py::test_get_not_a_file
		tests/test_cli.py::test_list_non_existent_file
		tests/test_cli.py::test_list_not_a_file
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install() {
	distutils-r1_python_install
	ln -s dotenv "${D}$(python_get_scriptdir)"/python-dotenv || die
}

src_install() {
	distutils-r1_src_install

	# Avoid collision with dev-ruby/dotenv (bug #798648)
	mv "${ED}"/usr/bin/{,python-}dotenv || die
}
