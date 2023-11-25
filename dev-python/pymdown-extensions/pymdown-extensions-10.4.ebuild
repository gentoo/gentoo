# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Extensions for Python Markdown"
HOMEPAGE="
	https://github.com/facelessuser/pymdown-extensions/
	https://pypi.org/project/pymdown-extensions/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/pygments-2.12.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
