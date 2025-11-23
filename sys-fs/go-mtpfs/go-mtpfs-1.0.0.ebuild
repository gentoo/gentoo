# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="a simple FUSE filesystem for mounting Android devices as a MTP device"
HOMEPAGE="https://github.com/hanwen/go-mtpfs"
SRC_URI="https://github.com/hanwen/go-mtpfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="virtual/libusb:1
		virtual/udev"
DEPEND="${COMMON_DEPEND}
	media-libs/libmtp"
RDEPEND="${COMMON_DEPEND}"

#Tests require a connected mtp device
RESTRICT+=" test"

src_compile() {
	ego build -ldflags '-extldflags=-fno-PIC' .
}

src_test() {
	ego test -ldflags '-extldflags=-fno-PIC' fs
	ego test -ldflags '-extldflags=-fno-PIC' usb
	ego test -ldflags '-extldflags=-fno-PIC' mtp
}

src_install() {
	dobin go-mtpfs
dodoc README.md
}
