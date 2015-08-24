# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="C/C++ function library for rasterizing 2-D vector graphics"
HOMEPAGE="https://www.gnu.org/software/libxmi/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="!<=media-libs/plotutils-2.6"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		-i configure.in || die
	autotools-utils_src_prepare
}
