# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Signature generator for Python programs"
HOMEPAGE="
	https://mkdocstrings.github.io/griffe/
	https://github.com/mkdocstrings/griffe/
	https://pypi.org/project/griffe/
"
# Tests need files absent from the PyPI tarballs
SRC_URI="
	https://github.com/mkdocstrings/griffe/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/colorama-0.4[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/backports-strenum-1.3[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		>=dev-python/jsonschema-4.17[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-0.28.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=(
		# fragile to installed packages
		# (failed on PySide2 for me)
		tests/test_stdlib.py::test_fuzzing_on_stdlib
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# https://github.com/pypy/pypy/issues/5226
				tests/test_inspector.py::test_inspecting_objects_from_private_builtin_stdlib_moduless
			)
			;&
		pypy3*)
			EPYTEST_DESELECT+=(
				# tries importing CPython-specific modules
				# https://github.com/mkdocstrings/griffe/issues/362
				tests/test_loader.py::test_load_builtin_modules
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
