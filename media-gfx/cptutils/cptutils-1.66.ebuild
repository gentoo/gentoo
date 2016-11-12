# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

CDEPEND="dev-libs/libxml2:2
	media-libs/libpng:0="
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	test? ( app-text/xmlstarlet )"

PATCHES=( "${FILESDIR}"/${PN}-1.54-parallel-make.patch )

src_prepare() {
	default
	python_fix_shebang src/gradient-convert/gradient-convert.py
}
