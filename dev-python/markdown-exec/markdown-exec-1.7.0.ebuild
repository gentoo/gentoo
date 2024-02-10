# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Utilities to execute code blocks in Markdown files"
HOMEPAGE="
	https://pawamoy.github.io/markdown-exec/
	https://pypi.org/project/markdown-exec/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="ansi"

RDEPEND="
	>=dev-python/pymdown-extensions-9[${PYTHON_USEDEP}]
	ansi? (
		dev-python/pygments-ansi-color[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/markupsafe[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
