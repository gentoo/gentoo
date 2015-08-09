# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Creates windows installer on usb media from an iso image"
HOMEPAGE="http://en.congelli.eu/prog_info_winusb.html"
SRC_URI="http://en.congelli.eu/directdl/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND}
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/util-linux
	sys-block/parted
	sys-boot/grub:2
	sys-fs/ntfs3g
"

src_prepare() {
	sed -i "s#grub-install#grub2-install#" src/winusb ||
		die "sed failed"
}

src_compile() {
	return; # noop
}

src_configure() {
	return; # noop
}

src_install() {
	dosbin src/winusb
}
