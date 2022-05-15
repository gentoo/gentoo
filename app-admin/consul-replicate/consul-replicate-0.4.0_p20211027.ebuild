# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGIT_COMMIT=aceb253db329a6aefb48ac58dfc231e6947f73b2
KEYWORDS="~amd64"
DESCRIPTION="Consul cross-DC KV replication daemon"
HOMEPAGE="https://github.com/hashicorp/consul-replicate"
SRC_URI="https://github.com/hashicorp/consul-replicate/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_compile() {
	export GOBIN="${S}/bin"
	go install ./... || die
}

src_test() {
	go test -work ./... || die
}

src_install() {
	dobin bin/${PN}
	dodoc CHANGELOG.md README.md
}
