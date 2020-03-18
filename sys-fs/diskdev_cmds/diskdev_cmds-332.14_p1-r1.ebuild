# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV%_p*}

DESCRIPTION="HFS and HFS+ utils ported from OSX, supplies mkfs and fsck"
HOMEPAGE="http://opendarwin.org"
SRC_URI="http://darwinsource.opendarwin.org/tarballs/apsl/diskdev_cmds-${MY_PV}.tar.gz
		 mirror://gentoo/diskdev_cmds-${PV}.patch.bz2"
LICENSE="APSL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""
DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${WORKDIR}"/diskdev_cmds-${PV}.patch
	"${FILESDIR}"/diskdev_cmds-respect-cflags.patch
)

src_compile() {
	emake -f Makefile.lnx AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	into /
	dosbin fsck_hfs.tproj/fsck_hfs
	dosbin newfs_hfs.tproj/newfs_hfs
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
