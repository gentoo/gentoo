# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

KEYWORDS="~amd64"
DESCRIPTION="containers/storage library"
HOMEPAGE="https://github.com/containers/storage"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
IUSE="btrfs +device-mapper test"
EGO_PN="${HOMEPAGE#*//}"
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RDEPEND="
	btrfs? ( sys-fs/btrfs-progs )
	device-mapper? ( sys-fs/lvm2:= )"
DEPEND="${RDEPEND}
	dev-go/go-md2man
	test? (
		sys-fs/btrfs-progs
		sys-fs/lvm2
		sys-apps/util-linux
	)"
RESTRICT="test"

S=${WORKDIR}/${P#containers-}

src_prepare() {
	default

	sed -e 's:GO111MODULE=off:GO111MODULE=on:' -i Makefile || die

	[[ -f hack/btrfs_tag.sh ]] || die
	use btrfs || { echo -e "#!/bin/sh\necho exclude_graphdriver_btrfs" > \
		"hack/btrfs_tag.sh" || die; }

	[[ -f hack/libdm_tag.sh ]] || die
	use device-mapper || { echo -e "#!/bin/sh\necho btrfs_noversion exclude_graphdriver_devicemapper" > \
		"hack/libdm_tag.sh" || die; }
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678856
	emake containers-storage docs
}

src_install() {
	dobin "${PN}"
	while read -r -d ''; do
		mv "${REPLY}" "${REPLY%.1}" || die
	done < <(find "${S}/docs" -name '*.[[:digit:]].1' -print0)
	find "${S}/docs" -name '*.[[:digit:]]' -exec doman '{}' + || die
}

src_test() {
	GOPATH="${S}" unshare -m emake local-test-unit || die
}
