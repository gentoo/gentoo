# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A collection of helpers and mock objects for unit tests and doc tests"
HOMEPAGE="
	https://pypi.org/project/testfixtures/
	https://github.com/Simplistix/testfixtures/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		>=dev-python/sybil-6[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/twisted-18[${PYTHON_USEDEP}]
		' 3.{10..12})
		sys-libs/timezone-data
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
		python3.13)
			EPYTEST_DESELECT+=(
				# changed exception message
				testfixtures/tests/test_replace.py::TestReplaceWithInterestingOriginsNotStrict::test_invalid_attribute_on_instance_of_slotted_cl
			)
	esac

	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/twisted[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			testfixtures/tests/test_twisted.py
		)
	fi

	epytest
}
