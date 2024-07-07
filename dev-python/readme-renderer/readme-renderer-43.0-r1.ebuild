# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A library for rendering 'readme' descriptions for Warehouse"
HOMEPAGE="
	https://github.com/pypa/readme_renderer/
	https://pypi.org/project/readme-renderer/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/docutils-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/nh3-0.2.14[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.5.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/docutils-0.21.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

DOCS=( README.rst )

PATCHES=(
	# https://github.com/pypa/readme_renderer/pull/315
	"${FILESDIR}/${P}-docutils-0.21.patch"
)
