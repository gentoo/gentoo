# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/diskdev_cmds/diskdev_cmds-332.14.ebuild,v 1.3 2008/12/10 23:35:17 flameeyes Exp $

inherit eutils

DESCRIPTION="HFS and HFS+ utils ported from OSX, supplies mkfs and fsck"
HOMEPAGE="http://opendarwin.org"
SRC_URI="http://darwinsource.opendarwin.org/tarballs/apsl/diskdev_cmds-${PV}.tar.gz
		 mirror://gentoo/diskdev_cmds-${PV}.patch.bz2"
LICENSE="APSL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc ~x86"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/diskdev_cmds-${PV}.patch
}

src_compile() {
	emake -f Makefile.lnx || die "emake failed"
}

src_install() {
	exeinto /sbin
	doexe fsck_hfs.tproj/fsck_hfs
	doexe newfs_hfs.tproj/newfs_hfs
	dosym /sbin/newfs_hfs /sbin/mkfs.hfs
	dosym /sbin/newfs_hfs /sbin/mkfs.hfsplus
	dosym /sbin/fsck_hfs /sbin/fsck.hfs
	dosym /sbin/fsck_hfs /sbin/fsck.hfsplus
	doman newfs_hfs.tproj/newfs_hfs.8
	newman newfs_hfs.tproj/newfs_hfs.8 mkfs.hfs.8
	newman newfs_hfs.tproj/newfs_hfs.8 mkfs.hfsplus.8
	doman fsck_hfs.tproj/fsck_hfs.8
	newman fsck_hfs.tproj/fsck_hfs.8 fsck.hfs.8
	newman fsck_hfs.tproj/fsck_hfs.8 fsck.hfsplus.8
}
