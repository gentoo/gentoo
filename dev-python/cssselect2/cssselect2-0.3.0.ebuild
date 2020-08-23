# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="https://cssselect.readthedocs.io/en/latest/
	https://pypi.org/project/cssselect/
	https://github.com/Kozea/cssselect2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/tinycss2[${PYTHON_USEDEP}]
	dev-python/webencodings[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	# junk deps
	sed -i -e '/^addopts/d' -e '/pytest-runner/d' setup.cfg || die
	distutils-r1_src_prepare
}
