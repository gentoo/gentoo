# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="http://protobuf.dev"
SRC_URI="https://github.com/protocolbuffers/protobuf-go/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/protobuf"

src_compile() {
	ego build ./cmd/protoc-gen-go
}

src_install() {
dobin protoc-gen-go
}
