# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Tools to help build and install Jupyter Python packages"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/jupyter-packaging/
	https://pypi.org/project/jupyter-packaging/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/setuptools-60.2.0[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/deprecation[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/build[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# require Internet
		tests/test_build_api.py::test_build_package
		tests/test_build_api.py::test_deprecated_metadata
	)

	epytest -o tmp_path_retention_policy=all
}
