# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/cloudflare/${PN}/..."
EGIT_COMMIT="1a5ac2e68991e01380068b96f50f5ff982d9bb14"
EGO_VENDOR=( "github.com/juju/ratelimit acf38b000a03e4ab89e40f20f1e548f4e6ac7f72" )
inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Cloudflare's PKI and TLS toolkit"
HOMEPAGE="https://github.com/cloudflare/cfssl"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="BSD-2"
SLOT="0"
IUSE="hardened"

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	pushd src || die
		GOPATH="${S}" go install github.com/cloudflare/cfssl/cmd/... || die
	popd || die
}

src_install() {
	dobin bin/*
	pushd src/${EGO_PN%/*} || die
	dodoc CHANGELOG README.md
	popd || die
}
