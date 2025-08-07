# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

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
"
BDEPEND="
	test? (
		>=dev-python/jsonschema-4.17[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-0.28.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-xdist )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile to installed packages
	# (failed on PySide2 for me)
	tests/test_stdlib.py::test_fuzzing_on_stdlib
)

export PDM_BUILD_SCM_VERSION=${PV}
