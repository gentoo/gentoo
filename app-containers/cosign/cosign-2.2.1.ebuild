# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_HASH=12cbf9ea177d22bbf5cf028bcb4712b5f174ebc6
SOURCE_DATE_EPOCH=1699360786

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
