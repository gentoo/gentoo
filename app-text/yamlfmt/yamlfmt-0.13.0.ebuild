# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

EGIT_COMMIT=dd8547d
DESCRIPTION="An extensible command line tool or library to format yaml files"
HOMEPAGE="https://github.com/google/yamlfmt"
SRC_URI="https://github.com/google/yamlfmt/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
LICENSE+=" BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	CGO_ENABLED=0 ego build -ldflags "-X main.version=${PV} -X main.commit=${EGIT_COMMIT} -s -w" \
		-o yamlfmt ./cmd/yamlfmt
}

src_install() {
	dodoc -r README.md docs
	dobin yamlfmt
}

src_test() {
	emake test
}
