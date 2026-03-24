# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="
	https://github.com/Calysto/metakernel/
	https://pypi.org/project/metakernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/comm-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.22.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.19.0[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.9.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/ipython-9.0[${PYTHON_USEDEP}]
		>=dev-python/ipywidgets-8.0.5[${PYTHON_USEDEP}]
		>=dev-python/jupyter-kernel-test-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.29.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-timeout )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# fragile
		tests/test_parser.py::test_path_completions
		# broken by color codes in output
		# https://github.com/Calysto/metakernel/issues/266
		tests/test_replwrap.py::REPLWrapTestCase::test_bash
		# requires starting ipycluster
		tests/magics/test_parallel_magic.py::test_parallel_magic
	)

	case ${EPYTHON} in
		python3.1[34])
			EPYTEST_DESELECT+=(
				# "not stdin handler available"
				tests/test_replwrap.py::REPLWrapTestCase::test_spawn_args
				tests/test_replwrap.py::REPLWrapTestCase::test_spawn_no_args
			)
			;;
	esac

	epytest
}
