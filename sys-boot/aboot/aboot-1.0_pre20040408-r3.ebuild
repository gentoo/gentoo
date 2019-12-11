# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

KERN_VER="2.6.22"

DESCRIPTION="Alpha Linux boot loader for SRM"
HOMEPAGE="http://aboot.sourceforge.net/"
SRC_URI="http://aboot.sourceforge.net/tarballs/${P}.tar.bz2
	mirror://gentoo/gentoo-headers-base-${KERN_VER}.tar.bz2
	mirror://gentoo/${PN}_gentoo.diff.bz2
	https://dev.gentoo.org/~armin76/dist/${PN}_gentoo.diff.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* alpha"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	# setup local copies of kernel headers since we rely so
	# heavily on linux internals.
	mv gentoo-headers-base-${KERN_VER}/include/{linux,asm-generic,asm-alpha} "${S}"/include/ || die
	cd "${S}"/include
	ln -s asm-alpha asm || die
	touch linux/config.h || die
}

src_prepare() {
	eapply "${FILESDIR}/aboot-gcc-3.4.patch"
	eapply "${FILESDIR}/aboot-pt_note.patch"
	# Bug 364697
	eapply "${FILESDIR}/aboot-define_stat_only_in_userspace.patch"
	eapply "${FILESDIR}"/aboot-respect-AR.patch
	eapply "${FILESDIR}"/aboot-gnu90.patch

	# Modified patch from Debian to add netboot support
	eapply "${WORKDIR}"/aboot_gentoo.diff

	eapply_user
}

src_compile() {
	# too many problems with parallel building
	emake -j1 AR=$(tc-getAR) CC=$(tc-getCC) LD=$(tc-getLD)
}

src_install() {
	dodir /boot /sbin /usr/share/man/man{1,5,8}
	make \
		root="${D}" \
		bindir="${D}"/sbin \
		bootdir="${D}"/boot \
		mandir="${D}"/usr/share/man \
		install

	insinto /boot
	doins net_aboot.nh
	dobin netabootwrap
	dodoc ChangeLog INSTALL README TODO aboot.conf

	insinto /etc
	newins "${FILESDIR}"/aboot.conf aboot.conf.example

}

pkg_postinst() {
	einfo "To make aboot install a new bootloader on your harddisk follow"
	einfo "these steps:"
	einfo ""
	einfo " - edit the file /etc/aboot.conf"
	einfo " - cd /boot"
	einfo " - swriteboot -c2 /dev/sda bootlx"
	einfo " This will install a new bootsector on /dev/sda and aboot will"
	einfo " use the second partition on this device to lookup kernel and "
	einfo " initrd (as described in the aboot.conf file)"
	einfo ""
	einfo "IMPORTANT :"
	einfo ""
	einfo "The partition table of your boot device has to contain "
	einfo "a BSD-DISKLABEL and the first 12 megabytes of your boot device"
	einfo "must not be part of a partition as aboot will write its bootloader"
	einfo "in there and not as with most x86 bootloaders into the "
	einfo "master boot sector. If your partition table does not reflect this"
	einfo "you are going to destroy your installation !"
	einfo "Also note that aboot currently only supports ext2/3 partitions"
	einfo "to boot from."
}
