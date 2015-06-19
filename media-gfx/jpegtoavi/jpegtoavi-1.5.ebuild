# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jpegtoavi/jpegtoavi-1.5.ebuild,v 1.1 2010/03/02 21:11:58 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="JPEG to AVI/MJPEG animation command-line conversion tool"
HOMEPAGE="http://sourceforge.net/projects/jpegtoavi/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1
	dodoc CHANGELOG README
}
