# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGIT_COMMIT="7e8114a82da342cdbec9a518c5c6a1cce58105e9"

DESCRIPTION="Docker-compatible CLI for containerd, with support for Compose"
HOMEPAGE="https://github.com/containerd/nerdctl"
SRC_URI="
	https://github.com/containerd/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/containerd/${PN}/releases/download/v${PV}/${P}-go-mod-vendor.tar.gz
"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}"
	unpack "${P}-go-mod-vendor.tar.gz"
}

src_compile() {
	emake VERSION=v${PV} REVISION="${EGIT_COMMIT}"
}

src_install() {
	emake DESTDIR="${D}" VERSION=v${PV} REVISION="${EGIT_COMMIT}" BINDIR="/usr/bin" install
	DOCS=( README.md docs/* examples )
	einstalldocs
}
