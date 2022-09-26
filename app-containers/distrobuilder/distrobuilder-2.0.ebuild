# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info

DESCRIPTION="System container image builder for LXC and LXD"
HOMEPAGE="https://linuxcontainers.org/distrobuilder/introduction/"

SRC_URI="https://github.com/lxc/distrobuilder/archive/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	dev-util/debootstrap
	app-crypt/gnupg
	sys-fs/squashfs-tools
	dev-vcs/git
	net-misc/rsync
	"

CONFIG_CHECK="~OVERLAY_FS"
RESTRICT=" test"

S="${WORKDIR}/${PN}-${P}"

src_compile() {
	GOBIN="${S}/bin" ego install ./...
}

src_install() {
	dobin bin/*
	dodoc -r doc/*
}
