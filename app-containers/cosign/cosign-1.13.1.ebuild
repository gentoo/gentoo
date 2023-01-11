# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GIT_HASH=d1c6336475b4be26bb7fb52d97f56ea0a1767f9f
inherit go-module

DESCRIPTION="container signing utility"
HOMEPAGE="https://sigstore.dev"
SRC_URI="https://github.com/sigstore/cosign/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

src_compile() {
	emake \
		GIT_HASH=${GIT_HASH} \
		GIT_VERSION=v${PV} \
		GIT_TREESTATE=clean
}

src_install() {
	dobin cosign
	einstalldocs
dodoc CHANGELOG.md
}
