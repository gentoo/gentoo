# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Tools to help build and install Jupyter Python packages"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/deprecation[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# TODO: package "build"
		tests/test_build_api.py::test_build_package
		tests/test_build_api.py::test_deprecated_metadata

		# broken by Gentoo pip patch
		# TODO: retry when we finally make the patch less intrusive
		tests/test_datafiles_install.py
		tests/test_install.py
	)

	distutils_install_for_testing --via-venv
	epytest ${deselect[@]/#/--deselect }
}
