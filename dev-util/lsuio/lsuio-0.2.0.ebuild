# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="list available userspace I/O (UIO) devices"
HOMEPAGE="http://www.osadl.org/UIO.uio.0.html"
SRC_URI="http://www.osadl.org/projects/downloads/UIO/user/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS NEWS README
}
