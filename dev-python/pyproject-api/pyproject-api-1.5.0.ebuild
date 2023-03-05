# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="API to interact with the python pyproject.toml based projects"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-api/
	https://pypi.org/project/pyproject-api/
"
SRC_URI="
	https://github.com/tox-dev/pyproject-api/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
"
BDEPEND="
	>=dev-python/hatch-vcs-0.2[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.10[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20.17[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

EPYTEST_DESELECT=(
	# requires Python 2 installed
	tests/test_frontend.py::test_can_build_on_python_2
)
