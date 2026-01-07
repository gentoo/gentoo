# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_HASH=3f32cea203c59a93323a6bebfebff03417520143
SOURCE_DATE_EPOCH=1765324943

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
		GIT_TREESTATE=clean \
		SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}
}

src_install() {
	dobin cosign
	einstalldocs
dodoc CHANGELOG.md
}
