# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python Package to write SVG files"
HOMEPAGE="https://github.com/mozman/svgwrite"
SRC_URI="https://github.com/mozman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

src_prepare() {
	# fetches from the Internet
	sed -i -e 's:test_embed_google_web_font:_&:' \
		tests/test_style.py || die
	distutils-r1_src_prepare
}
