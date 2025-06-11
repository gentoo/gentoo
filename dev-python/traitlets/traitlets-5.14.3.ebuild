# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A configuration system for Python applications"
HOMEPAGE="
	https://github.com/ipython/traitlets/
	https://pypi.org/project/traitlets/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

BDEPEND="
	test? (
		>=dev-python/argcomplete-2.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source \
	dev-python/myst-parser \
	dev-python/pydata-sphinx-theme
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		tests/test_typing.py
	)

	if [[ ${EPYTHON} == python3.14 ]]; then
		# fails due to improved error messages in Python 3.14
		# https://github.com/ipython/traitlets/issues/925
		local EPYTEST_DESELECT=(
			tests/config/test_argcomplete.py::TestArgcomplete::test_complete_simple_app
			tests/config/test_argcomplete.py::TestArgcomplete::test_complete_custom_completers
			tests/config/test_argcomplete.py::TestArgcomplete::test_complete_subcommands_subapp1
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
