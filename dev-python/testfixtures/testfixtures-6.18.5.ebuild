# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A collection of helpers and mock objects for unit tests and doc tests"
HOMEPAGE="https://pypi.org/project/testfixtures/ https://github.com/Simplistix/testfixtures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/sybil[${PYTHON_USEDEP}]
		>=dev-python/twisted-18[${PYTHON_USEDEP}]
		dev-python/zope-component[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# kill weird way of declaring build deps
	sed -e '/build=/d' -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTHONPATH="."
	local -x DJANGO_SETTINGS_MODULE=testfixtures.tests.test_django.settings

	local EPYTEST_DESELECT=(
		# TODO
		testfixtures/tests/test_shouldwarn.py::ShouldWarnTests::test_filter_missing
		testfixtures/tests/test_shouldwarn.py::ShouldWarnTests::test_filter_present
	)

	epytest
}
