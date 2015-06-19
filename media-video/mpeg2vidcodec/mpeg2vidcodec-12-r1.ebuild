# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mpeg2vidcodec/mpeg2vidcodec-12-r1.ebuild,v 1.35 2013/04/20 09:38:08 ulm Exp $

EAPI=4

inherit toolchain-funcs

MY_P="${PN}_v${PV}"
DESCRIPTION="MPEG Library"
HOMEPAGE="http://www.mpeg.org/"
SRC_URI="http://www.mpeg.org/pub_ftp/mpeg/mssg/${MY_P}.tar.gz"

LICENSE="mpeg2enc"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""
RESTRICT="mirror bindist" #465088

S=${WORKDIR}/mpeg2

src_prepare() {
	sed -i -e 's:make:$(MAKE):' Makefile || die

	sed -i -e 's:$(CC) $(CFLAGS):\0 $(LDFLAGS):' \
		src/mpeg2enc/Makefile src/mpeg2dec/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/mpeg2dec/mpeg2decode src/mpeg2enc/mpeg2encode
	dodoc README doc/*
}
