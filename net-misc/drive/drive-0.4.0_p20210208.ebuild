# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Google Drive client for the commandline"
HOMEPAGE="https://github.com/odeke-em/drive"
EGIT_COMMIT="bede608f250a9333d55c43396fc5e72827e806fd"
SRC_URI="https://github.com/odeke-em/drive/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

KEYWORDS="amd64"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE=""
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_prepare() {
	sed -e "s|qrcode.Encode(uri,|\0 qrcode.Medium,|" -i drive-server/main.go || die
	default
}

src_compile() {
	CGO_ENABLED=0 go build -o ./bin/drive ./cmd/drive || die
	CGO_ENABLED=0 go build -o ./bin/drive-server ./drive-server || die
}

src_install() {
	dodoc "README.md"
	dobin bin/drive bin/drive-server
}
