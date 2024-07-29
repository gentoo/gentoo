# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..13} )

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
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/colorama-0.4[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/backports-strenum-1.3[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		>=dev-python/jsonschema-4.17[${PYTHON_USEDEP}]
		dev-python/mkdocstrings[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}

EPYTEST_DESELECT=(
	# fragile to installed packages
	# (failed on PySide2 for me)
	tests/test_stdlib.py::test_fuzzing_on_stdlib
)
