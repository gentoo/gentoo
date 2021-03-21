# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A python utility/library to sort imports"
HOMEPAGE="https://pypi.org/project/isort/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pylama[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest

python_test() {
	# Some tests run the "isort" command
	distutils_install_for_testing

	local skipped_tests=(
		# Fails without -s, run it separately to avoid unnecessary output
		tests/unit/test_importable.py
		# Excluded from upstream's test script
		tests/unit/test_deprecated_finders.py
		# Require "example_isort_formatting_plugin", we're not going
		# to add an example package just to run a few tests
		tests/unit/test_literal.py::test_value_assignment_list
		tests/unit/test_ticketed_features.py::test_isort_supports_formatting_plugins_issue_1353
		tests/unit/test_ticketed_features.py::test_isort_literals_issue_1358
		# Same here: requires "example_shared_isort_profile"
		tests/unit/test_ticketed_features.py::test_isort_supports_shared_profiles_issue_970
	)
	epytest -s tests/unit/test_importable.py
	epytest tests/unit ${skipped_tests[@]/#/--deselect }
}
