# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/apngdis/apngdis-2.7.ebuild,v 1.1 2014/10/11 21:07:20 radhermit Exp $

EAPI="5"

inherit toolchain-funcs eutils

DESCRIPTION="extract PNG frames from an APNG"
HOMEPAGE="http://sourceforge.net/projects/apngdis/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6-makefile.patch
	epatch "${FILESDIR}"/${PN}-2.6-gcc-4.3.patch

	tc-export CXX
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
