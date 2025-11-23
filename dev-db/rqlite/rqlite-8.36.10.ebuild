# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
EGIT_COMMIT=768eafc309ff05a57d041d2b19f67994ce83a5c5

DESCRIPTION="Replicated SQLite using the Raft consensus protocol"
HOMEPAGE="https://github.com/rqlite/rqlite https://www.philipotoole.com/tag/rqlite/"
SRC_URI="https://github.com/rqlite/rqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="MIT"
LICENSE+=" Apache-2.0 BSD CC0-1.0 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_unpack() {
	default
}

src_prepare() {
	ln -sv ../vendor ./ || die
	default
}

src_compile() {
	GOBIN="${S}/bin" \
		ego install \
			-ldflags="-X main.version=v${PV}
				-X main.branch=master
				-X main.commit=${EGIT_COMMIT}
				-X main.buildtime=$(date +%Y-%m-%dT%T%z)" \
			./cmd/... || die
}

src_test() {
	GOBIN="${S}/bin" \
		ego test ./... || die
}

src_install() {
	dobin bin/*
	dodoc -r *.md DOC
}
