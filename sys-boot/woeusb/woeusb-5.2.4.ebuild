# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Creates windows installer on usb media from an iso image"
HOMEPAGE="https://github.com/WoeUSB/WoeUSB"
SRC_URI="https://github.com/WoeUSB/WoeUSB/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/WoeUSB-${PV}"

LICENSE="CC-BY-SA-4.0 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/wimlib
	sys-apps/util-linux
	sys-block/parted
	sys-boot/grub:2[grub_platforms_pc]
	sys-fs/dosfstools
	sys-fs/ntfs3g"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i "s/@@WOEUSB_VERSION@@/${PV}/" sbin/${PN} share/man/man1/${PN}.1 || die
}

src_install() {
	dosbin sbin/${PN}
	doman share/man/man1/${PN}.1

	einstalldocs
}
