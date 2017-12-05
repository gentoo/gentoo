# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A number of utilities for the manipulation of color gradient files"
HOMEPAGE="http://soliton.vm.bytemark.co.uk/pub/jjg/en/code/cptutils/"
SRC_URI="http://soliton.vm.bytemark.co.uk/pub/jjg/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="dev-libs/libxml2:2
	media-libs/libpng:0="
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	test? (
		app-text/xmlstarlet
		>=dev-util/cunit-2.1_p3
	)"

PATCHES=( "${FILESDIR}"/${P}-parallel-make.patch )

src_prepare() {
	default
	python_fix_shebang src/gradient-convert/gradient-convert.py
}

src_configure() {
	econf $(use_enable test tests)
}

src_test() {
	emake unit
}
