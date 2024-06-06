# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/dfu-util/dfu-util"
	inherit autotools git-r3
else
	SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~riscv x86"
fi

DESCRIPTION="implements the Host (PC) side of the USB DFU (Device Firmware Upgrade) protocol"
HOMEPAGE="https://dfu-util.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}
