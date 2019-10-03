# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_VENDOR=(
	"google.golang.org/grpc v1.24.0 github.com/grpc/grpc-go"
	"golang.org/x/net 2ec189313ef0a07735684caebd1ba8b8ebca456f github.com/golang/net"
	"google.golang.org/genproto c459b9ce5143dd819763d9329ff92a8e35e61bd9 github.com/google/go-genproto"
	"golang.org/x/sys b397fe3ad8ed895c98fa54584f61835a88e65ff5 github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
)

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="https://github.com/golang/protobuf"
SRC_URI="https://github.com/golang/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( $(go-module_vendor_uris) )"
# LICENSE omits licenses for EGO_VENDOR packages, since those are only
# test dependencies which are not used at runtime.
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
DEPEND="test? ( dev-libs/protobuf )"
RDEPEND=""
RESTRICT="!test? ( test )"
S=${WORKDIR}/${P#go-}

src_unpack() {
	if use test; then
		go-module_src_unpack
	else
		default
	fi
}

src_compile() {
	export GOBIN=${S}/bin
	default
}

src_install() {
	dobin "${GOBIN}"/*
	dodoc README.md
}
