# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Build multiple documentation folders in a single Mkdocs"
HOMEPAGE="
	https://backstage.github.io/mkdocs-monorepo-plugin/
	https://pypi.org/project/mkdocs-monorepo-plugin/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/mkdocs-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-4.0.1[${PYTHON_USEDEP}]
"

# Data files required by this test are not included in PyPI tarballs,
# and upstream has not tagged any releases in their GitHub repository since 2019.
EPYTEST_DESELECT=(
	mkdocs_monorepo_plugin/tests/test_plugin.py::TestMonorepoPlugin::test_plugin_on_config_with_nav
)

distutils_enable_tests pytest
