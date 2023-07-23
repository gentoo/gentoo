# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A collection of helpers and mock objects for unit tests and doc tests"
HOMEPAGE="
	https://pypi.org/project/testfixtures/
	https://github.com/Simplistix/testfixtures/
"

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

distutils_enable_sphinx docs \
	dev-python/furo
distutils_enable_tests pytest

python_test() {
	local -x PYTHONPATH="."
	local -x DJANGO_SETTINGS_MODULE=testfixtures.tests.test_django.settings

	local EPYTEST_DESELECT=(
		# TODO
		testfixtures/tests/test_shouldwarn.py::ShouldWarnTests::test_filter_missing
		testfixtures/tests/test_shouldwarn.py::ShouldWarnTests::test_filter_present
	)

	case ${EPYTHON} in
		python3.12)
			EPYTEST_DESELECT+=(
				# https://github.com/simplistix/testfixtures/issues/183
				docs/comparing.txt::line:642,column:1
				docs/comparing.txt::line:784,column:1
				docs/comparing.txt::line:823,column:1
				testfixtures/tests/test_tempdirectory.py::TempDirectoryTests::test_as_path_relative_sequence
				testfixtures/tests/test_tempdirectory.py::TempDirectoryTests::test_as_path_relative_string
			)
			;;
	esac

	epytest
}
