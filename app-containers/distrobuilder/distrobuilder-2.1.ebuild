# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

DESCRIPTION="System container image builder for LXC and LXD"
HOMEPAGE="https://linuxcontainers.org/distrobuilder/introduction/"

SRC_URI="https://linuxcontainers.org/downloads/distrobuilder/distrobuilder-${PV}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/distrobuilder/distrobuilder-${PV}.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="verify-sig"

RDEPEND="app-crypt/gnupg
	dev-util/debootstrap
	dev-vcs/git
	net-misc/rsync
	sys-fs/squashfs-tools"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-linuxcontainers )"

# Test deps aren't vendored.
RESTRICT="test"

CONFIG_CHECK="~OVERLAY_FS"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/linuxcontainers.asc

PATCHES=( "${FILESDIR}"/distrobuilder-2.1-glibc-2.36-fix.patch )

GOPATH="${S}/_dist"

src_compile() {
	export GOPATH="${S}/_dist"
	emake
}

src_test() {
	export GOPATH="${S}/_dist"
	emake check
}

src_install() {
	export GOPATH="${S}/_dist"
	dobin ${GOPATH}/bin/distrobuilder
	dodoc -r doc/*
}
