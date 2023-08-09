# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Plugin for Mkdocs page redirects"
HOMEPAGE="
	https://github.com/mkdocs/mkdocs-redirects
	https://pypi.org/project/mkdocs-redirects/
"
SRC_URI="
	https://github.com/mkdocs/mkdocs-redirects/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/mkdocs-1.0.4[${PYTHON_USEDEP}]
	<dev-python/mkdocs-2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
