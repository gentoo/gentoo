# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/cptutils/cptutils-1.59.ebuild,v 1.1 2015/07/10 03:23:12 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 eutils

DESCRIPTION="A number of utilities for the manipulation of color gradient files"
HOMEPAGE="http://soliton.vm.bytemark.co.uk/pub/jjg/en/code/cptutils/"
SRC_URI="http://soliton.vm.bytemark.co.uk/pub/jjg/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-libs/libxml2:2
	media-libs/libpng:0="
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}"
DEPEND="${CDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.54-parallel-make.patch
	python_fix_shebang src/gradient-convert/gradient-convert.py
}
