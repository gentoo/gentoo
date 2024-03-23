# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python dependency specifications supporting logical operations"
HOMEPAGE="
	https://github.com/pdm-project/dep-logic/
	https://pypi.org/project/dep-logic/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/packaging-22[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
