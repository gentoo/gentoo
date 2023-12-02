# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A rewrite of Python's builtin doctest module but without all the weirdness"
HOMEPAGE="
	https://github.com/Erotemic/xdoctest/
	https://pypi.org/project/xdoctest/
"
SRC_URI="
	https://github.com/Erotemic/xdoctest/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm64 ~x86"

# dev-python/nbformat-5.1.{0..2} did not install package data
BDEPEND="
	test? (
		>=dev-python/nbformat-5.1.2-r1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
#distutils_enable_sphinx docs/source \
#	dev-python/autoapi \
#	dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	tests/test_pytest_cli.py::test_simple_pytest_import_error_cli
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=xdoctest.plugin

	epytest --pyargs tests xdoctest
}
