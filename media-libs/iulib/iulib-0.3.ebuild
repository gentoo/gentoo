# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/iulib/iulib-0.3.ebuild,v 1.3 2010/11/08 15:13:00 ssuominen Exp $

inherit eutils

DESCRIPTION="easy-to-use image and video I/O functions"
HOMEPAGE="http://code.google.com/p/iulib/"
SRC_URI="http://iulib.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sdl"

DEPEND="sys-libs/zlib
	media-libs/libpng
	virtual/jpeg
	media-libs/tiff
	sdl? ( media-libs/libsdl )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-install.patch
}

src_compile() {
	econf $(use_with sdl SDL) || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc CHANGES README TODO
}
