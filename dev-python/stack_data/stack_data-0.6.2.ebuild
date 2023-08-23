# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Extract data from Python tracebacks for informative displays"
HOMEPAGE="
	https://github.com/alexmojaki/stack_data/
	https://pypi.org/project/stack-data/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/asttokens-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/executing-1.2.0[${PYTHON_USEDEP}]
	dev-python/pure_eval[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/typeguard[${PYTHON_USEDEP}]
		dev-python/littleutils[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-pygments-2.14.0.patch
)

distutils_enable_tests pytest
