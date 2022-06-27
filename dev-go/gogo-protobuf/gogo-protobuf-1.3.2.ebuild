# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Protocol Buffers for Go with Gadgets"
HOMEPAGE="https://github.com/gogo/protobuf"
SRC_URI="https://github.com/gogo/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"
S="${WORKDIR}/protobuf-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT+=" test"

src_compile() {
	GOBIN="${S}/bin" emake install
}

src_install() {
	dobin bin/*
	dodoc README
}
