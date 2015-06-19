# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/go-mtpfs/go-mtpfs-9999.ebuild,v 1.6 2015/05/11 16:26:57 mgorny Exp $

EAPI=5

inherit git-r3 flag-o-matic toolchain-funcs

DESCRIPTION="a simple FUSE filesystem for mounting Android devices as a MTP device"
HOMEPAGE="https://github.com/hanwen/go-mtpfs"
EGIT_REPO_URI="https://github.com/hanwen/go-mtpfs.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="virtual/libusb
		virtual/udev"
DEPEND="${COMMON_DEPEND}
	dev-libs/go-fuse
	dev-libs/go-usb
	dev-lang/go
	media-libs/libmtp"

RDEPEND="${COMMON_DEPEND}"

#Tests require a connected mtp device
RESTRICT="test"

GO_PN="github.com/hanwen/${PN}"
EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"
QA_FLAGS_IGNORED=usr/bin/go-mtpfs

export GOPATH="${S}"

src_compile() {
	go build -ldflags '-extldflags=-fno-PIC' -v -x -work ${GO_PN} || die
}

src_test() {
	go test -ldflags '-extldflags=-fno-PIC' ${GO_PN}/fs || die
	go test -ldflags '-extldflags=-fno-PIC' ${GO_PN}/usb || die
	go test -ldflags '-extldflags=-fno-PIC' ${GO_PN}/mtp || die
}

src_install() {
	dobin go-mtpfs
}
