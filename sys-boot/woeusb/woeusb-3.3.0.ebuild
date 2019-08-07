# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0-gtk3"

inherit autotools wxwidgets

DESCRIPTION="Creates windows installer on usb media from an iso image"
HOMEPAGE="https://github.com/slacka/WoeUSB"
SRC_URI="https://github.com/slacka/WoeUSB/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND="
	sys-apps/util-linux
	sys-block/parted
	sys-fs/dosfstools
	sys-fs/ntfs3g
	sys-boot/grub:2[grub_platforms_pc]
	!minimal? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/WoeUSB-${PV}"

src_prepare() {
	default
	find . -type f -print0 | xargs -0 sed -i "s/@@WOEUSB_VERSION@@/${PV}/" || die
	if ! use minimal; then
		setup-wxwidgets
		eautoreconf
	fi
}

src_configure() {
	! use minimal && default
}

src_compile() {
	! use minimal && default
}

src_test() {
	! use minimal && default
}

src_install() {
	if use minimal; then
		dosbin src/woeusb
		einstalldocs
	else
		default
	fi
}
