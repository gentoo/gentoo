# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info optfeature

DESCRIPTION="System container image builder for LXC and incus"
HOMEPAGE="https://linuxcontainers.org/distrobuilder/introduction/"

SRC_URI="https://linuxcontainers.org/downloads/distrobuilder/distrobuilder-${PV}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/distrobuilder/distrobuilder-${PV}.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="verify-sig"

RDEPEND="app-cdr/cdrtools
	app-crypt/gnupg
	dev-util/debootstrap
	dev-vcs/git
	net-misc/rsync
	sys-fs/squashfs-tools"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-linuxcontainers )"

# Test deps aren't vendored.
RESTRICT="test"

CONFIG_CHECK="~OVERLAY_FS"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/linuxcontainers.asc

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

pkg_postinst() {
	optfeature_header "Optional support"
	optfeature "building MS Windows images" app-arch/wimlib app-misc/hivex
}
