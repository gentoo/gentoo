# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module linux-info

DESCRIPTION="System container image builder for LXC and LXD"
HOMEPAGE="https://linuxcontainers.org/distrobuilder/introduction/"
SRC_URI="https://linuxcontainers.org/downloads/distrobuilder/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-util/debootstrap
	app-crypt/gnupg
	sys-fs/squashfs-tools
	dev-vcs/git
	net-misc/rsync
	"

CONFIG_CHECK="~OVERLAY_FS"
RESTRICT+=" test"

src_compile() {
	cd _dist/src/github.com/lxc/distrobuilder || die "cd failed"
	GO111MODULE="off" GOBIN="${S}/bin" GOPATH="${S}/_dist" \
		go install ./... || die "compile failed"
}

src_install() {
	dobin bin/*
}
