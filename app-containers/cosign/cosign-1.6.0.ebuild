# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GIT_HASH=4b2c3c0c8ee97f31b9dac3859b40e0a48b8648ee
inherit go-module

DESCRIPTION="container signing utility"
HOMEPAGE="https://sigstore.dev"
SRC_URI="https://github.com/sigstore/cosign/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-fix-makefile.patch
)

RESTRICT="test"

src_compile() {
	emake \
		GIT_HASH=${GIT_HASH}
		GIT_VERSION=v${PV} \
		GIT_TREESTATE=clean
}

src_install() {
	dobin cosign
	einstalldocs
}
