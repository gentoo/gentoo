# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/mattst88/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/anholt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~alpha"
fi

DESCRIPTION="Alpha Linux boot loader for SRM"
HOMEPAGE="https://github.com/mattst88/aboot https://sourceforge.net/projects/aboot/"

LICENSE="GPL-2"
SLOT="0"

BDEPEND="app-text/docbook-sgml-utils"

src_compile() {
	emake AR=$(tc-getAR) CC=$(tc-getCC) LD=$(tc-getLD) \
		all netabootwrap

	einfo "Building man pages"
	emake -C doc/man
}

src_install() {
	dodir /boot /sbin /usr/share/man/man{1,5,8}
	emake root="${D}" install

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
