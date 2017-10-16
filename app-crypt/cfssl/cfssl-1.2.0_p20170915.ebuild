# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/cloudflare/${PN}"
EGIT_COMMIT="7d88da830aad9d533c2fb8532da23f6a75331b52"
inherit golang-build golang-vcs-snapshot

SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Cloudflare's PKI and TLS toolkit"
HOMEPAGE="https://github.com/cloudflare/cfssl"
LICENSE="BSD-2"
SLOT="0"
IUSE="hardened"

RDEPEND="!!dev-lang/mono" #File collision (bug 614364)

RESTRICT="test"

src_compile() {
	pushd src || die
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" GOPATH="${S}" go install github.com/cloudflare/cfssl/cmd/... || die
	popd || die
}

src_install() {
	dobin bin/*
	pushd src/${EGO_PN} || die
	dodoc CHANGELOG README.md
	popd || die
}
