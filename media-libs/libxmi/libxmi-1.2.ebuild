# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libxmi/libxmi-1.2.ebuild,v 1.2 2013/05/04 21:04:58 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="C/C++ function library for rasterizing 2-D vector graphics"
HOMEPAGE="http://www.gnu.org/software/libxmi/"
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
