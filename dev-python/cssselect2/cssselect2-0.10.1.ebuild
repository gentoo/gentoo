# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYPI_VERIFY_REPO=https://github.com/Kozea/cssselect2
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="
	https://doc.courtbouillon.org/cssselect2/stable/
	https://pypi.org/project/cssselect2/
	https://github.com/Kozea/cssselect2/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/tinycss2[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
