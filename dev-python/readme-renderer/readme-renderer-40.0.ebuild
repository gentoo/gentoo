# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A library for rendering 'readme' descriptions for Warehouse"
HOMEPAGE="
	https://github.com/pypa/readme_renderer/
	https://pypi.org/project/readme-renderer/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/bleach-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.5.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst )

distutils_enable_tests pytest
