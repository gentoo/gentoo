# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="
	https://doc.courtbouillon.org/cssselect2/stable/
	https://pypi.org/project/cssselect2/
	https://github.com/Kozea/cssselect2/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-python/tinycss2[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pyproject.toml || die
	distutils-r1_src_prepare
}
