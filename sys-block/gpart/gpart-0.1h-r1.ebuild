# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Partition table rescue/guessing tool"
HOMEPAGE="http://www.stud.uni-hannover.de/user/76201/gpart/"
SRC_URI="http://www.stud.uni-hannover.de/user/76201/gpart/${P}.tar.gz
	ftp://ftp.namesys.com/pub/misc-patches/gpart-0.1h-reiserfs-3.6.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~hppa x86"
IUSE=""

RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-errno.patch
	epatch "${FILESDIR}"/${P}-vfat.patch
	epatch "${FILESDIR}"/${P}-ntfs.patch
	epatch "${FILESDIR}"/${P}-PIC.patch
	epatch "${FILESDIR}"/${P}-no-_syscall.patch
	epatch "${WORKDIR}"/gpart-0.1h-reiserfs-3.6.patch
	sed -i -e "/^CFLAGS/s: -O2 : ${CFLAGS} :" make.defs
}

src_install() {
	dobin src/gpart || die
	doman man/gpart.8
	dodoc README Changes INSTALL LSM
}
