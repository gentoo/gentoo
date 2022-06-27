# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A small utility which generates Go code from any file"
HOMEPAGE="https://github.com/go-bindata/go-bindata"
SRC_URI="https://github.com/go-bindata/go-bindata/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="CC-PD"
SLOT="0/${PVR}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64"

src_compile() {
	GOBIN=${S}/bin ego install ./go-bindata/
}

src_install() {
	dobin bin/*
	dodoc CONTRIBUTING.md README.md
}
