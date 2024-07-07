# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="MkDocs i18n plugin using static translation markdown files"
HOMEPAGE="
	https://github.com/ultrabug/mkdocs-static-i18n
	https://pypi.org/project/mkdocs-static-i18n/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-1.5.2[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		!!dev-python/mkdocs-i18n
	)
"

distutils_enable_tests pytest
