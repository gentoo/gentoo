# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="a simple FUSE filesystem for mounting Android devices as a MTP device"
HOMEPAGE="https://github.com/hanwen/go-mtpfs"

EGO_SUM=(
	"github.com/hanwen/go-fuse v0.0.0-20190726130028-2f298055551b"
	"github.com/hanwen/go-fuse v0.0.0-20190726130028-2f298055551b/go.mod"
	"github.com/hanwen/go-fuse v1.0.0"
	"github.com/hanwen/go-fuse v1.0.0/go.mod"
	"github.com/hanwen/go-fuse/v2 v2.0.1"
	"github.com/hanwen/go-fuse/v2 v2.0.1/go.mod"
	"github.com/hanwen/go-fuse/v2 v2.0.2"
	"github.com/hanwen/go-fuse/v2 v2.0.2/go.mod"
	"github.com/hanwen/usb v0.0.0-20141217151552-69aee4530ac7"
	"github.com/hanwen/usb v0.0.0-20141217151552-69aee4530ac7/go.mod"
	"github.com/kylelemons/godebug v0.0.0-20170820004349-d65d576e9348/go.mod"
	"github.com/kylelemons/godebug v1.1.0/go.mod"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522"
	"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
	"golang.org/x/sys v0.0.0-20190826190057-c7b8b68b1456"
	"golang.org/x/sys v0.0.0-20190826190057-c7b8b68b1456/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/hanwen/go-mtpfs/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

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
	go build -ldflags '-extldflags=-fno-PIC' . || die
}

src_test() {
	go test -ldflags '-extldflags=-fno-PIC' fs || die
	go test -ldflags '-extldflags=-fno-PIC' usb || die
	go test -ldflags '-extldflags=-fno-PIC' mtp || die
}

src_install() {
	dobin go-mtpfs
dodoc README.md
}
