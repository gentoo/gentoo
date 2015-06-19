# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/arm-fdisk/arm-fdisk-3.0.6.ebuild,v 1.8 2008/10/14 15:17:32 flameeyes Exp $

inherit eutils

DEB_VER=6
DESCRIPTION="edit disk partitions on Acorn machines"
HOMEPAGE="http://www.arm.linux.org.uk/"
SRC_URI="ftp://ftp.arm.linux.org.uk/pub/armlinux/source/other/${P}.tar.gz
	mirror://debian/pool/main/a/acorn-fdisk/acorn-fdisk_${PV}-${DEB_VER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc s390 sh sparc x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/acorn-fdisk_${PV}-${DEB_VER}.diff

	find "${S}" -name Makefile -print0 | xargs -0 \
		sed -i \
		-e "s:-O2 -Wall\( -g\)\?::" \
		-e "/^CFLAGS/s:=:+=:" \
		-e '/^STRIP/s:strip:true:'
}

src_install() {
	into /
	newsbin fdisk ${PN} || die "sbin failed"
	dosym ${PN} /sbin/acorn-fdisk
	dodoc ChangeLog README debian/changelog
}
