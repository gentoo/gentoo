# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Performance Test of Filesystem I/O using standard C library calls"
HOMEPAGE="http://www.textuality.com/bonnie/"
SRC_URI="http://www.textuality.com/bonnie/bonnie.tar.gz"

LICENSE="bonnie"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A} || die
	epatch "${FILESDIR}"/bonnie_man.patch
	epatch "${FILESDIR}"/Makefile.patch
}

src_compile() {
	make SYSFLAGS="${CFLAGS}" || die
	mv Bonnie bonnie
}

src_install() {
	doman bonnie.1
	dodoc Instructions
	dobin bonnie
}
