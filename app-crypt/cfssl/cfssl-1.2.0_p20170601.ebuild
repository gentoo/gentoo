# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/cloudflare/${PN}"
EGIT_COMMIT="9c06c53d4dfb9c0272c983a26ea10a6a2da12392"
inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Cloudflare's PKI and TLS toolkit"
HOMEPAGE="https://github.com/cloudflare/cfssl"
SRC_URI="${ARCHIVE_URI}"
LICENSE="BSD-2"
SLOT="0"
IUSE="hardened"

RESTRICT="test"

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	pushd src || die
		GOPATH="${S}" go install github.com/cloudflare/cfssl/cmd/... || die
	popd || die
}

src_install() {
	dobin bin/*
	pushd src/${EGO_PN} || die
	dodoc CHANGELOG README.md
	popd || die
}
