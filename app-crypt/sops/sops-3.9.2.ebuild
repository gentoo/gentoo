# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Simple And Flexible Tool For Managing Secrets"
HOMEPAGE="https://getsops.io/"
SRC_URI="https://github.com/getsops/sops/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/Arian-D/sops-deps/releases/download/${PV}/${P}-vendor.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"

KEYWORDS="amd64 ~arm64"

src_compile() {
	ego build || die
}

src_test() {
	ego test || die
}

src_install() {
	GOBIN="${S}/bin" ego install ./... || die
	dobin bin/${PN}
	dodoc README.rst
	default
}
