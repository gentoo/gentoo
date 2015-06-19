# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/diskdev_cmds/diskdev_cmds-332.14_p1.ebuild,v 1.6 2013/08/02 11:34:46 maekke Exp $

inherit eutils

MY_PV=${PV%_p*}

DESCRIPTION="HFS and HFS+ utils ported from OSX, supplies mkfs and fsck"
HOMEPAGE="http://opendarwin.org"
SRC_URI="http://darwinsource.opendarwin.org/tarballs/apsl/diskdev_cmds-${MY_PV}.tar.gz
		 mirror://gentoo/diskdev_cmds-${PV}.patch.bz2"
LICENSE="APSL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""
DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/diskdev_cmds-${PV}.patch
	epatch "${FILESDIR}"/diskdev_cmds-respect-cflags.patch
}

src_compile() {
	emake -f Makefile.lnx || die "emake failed"
}

src_install() {
	into /
	dosbin fsck_hfs.tproj/fsck_hfs || die "dosbin fsck failed"
	dosbin newfs_hfs.tproj/newfs_hfs || die "dosbin newfs failed"
	dosym /sbin/newfs_hfs /sbin/mkfs.hfs || die "dosym mkfs.hfs failed"
	dosym /sbin/newfs_hfs /sbin/mkfs.hfsplus || die "dosym mkfs.hfsplus failed"
	dosym /sbin/fsck_hfs /sbin/fsck.hfs || die "dosym fsck.hfs failed"
	dosym /sbin/fsck_hfs /sbin/fsck.hfsplus || die "dosym fsck.hfsplus failed"
	doman newfs_hfs.tproj/newfs_hfs.8 || die "doman newfs_hfs.8 failed"
	newman newfs_hfs.tproj/newfs_hfs.8 mkfs.hfs.8 || die "doman mkfs.hfs.8 failed"
	newman newfs_hfs.tproj/newfs_hfs.8 mkfs.hfsplus.8 || die "doman mkfs.hfsplus.8 failed"
	doman fsck_hfs.tproj/fsck_hfs.8 || die "doman fsck_hfs.8 failed"
	newman fsck_hfs.tproj/fsck_hfs.8 fsck.hfs.8 || die "doman fsck.hfs.8 failed"
	newman fsck_hfs.tproj/fsck_hfs.8 fsck.hfsplus.8 || die "doman fsck.hfsplus.8 failed"
}
