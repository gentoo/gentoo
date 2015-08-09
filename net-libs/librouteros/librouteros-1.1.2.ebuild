# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base autotools-utils autotools

DESCRIPTION="Library for accessing MikroTik's RouterOS via its API"
HOMEPAGE="http://verplant.org/librouteros/"
SRC_URI="http://verplant.org/librouteros/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug static-libs"

DEPEND="dev-libs/libgcrypt:0"
RDEPEND="${DEPEND}"

DOCS=(README AUTHORS)
PATCHES=("${FILESDIR}"/disable_werror.patch)

src_prepare(){
	base_src_prepare
	eautoreconf
}
