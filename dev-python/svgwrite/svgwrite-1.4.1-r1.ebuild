# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python Package to write SVG files"
HOMEPAGE="
	https://github.com/mozman/svgwrite/
	https://pypi.org/project/svgwrite/
"
SRC_URI="
	https://github.com/mozman/svgwrite/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

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
