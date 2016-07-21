# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit autotools base

DESCRIPTION="An open implementation of the MFC/R2 telephony signaling protocol"
HOMEPAGE="http://libopenr2.org/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-misc/dahdi"
PATCHES=( "${FILESDIR}/${PV}-respect-user-cflags.patch" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
}
