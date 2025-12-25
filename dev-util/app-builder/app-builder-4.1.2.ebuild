# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Generic helper tool to build app in a distributable formats."
HOMEPAGE="https://github.com/develar/app-builder"

COMMIT_ID="4e2aa6a12e2bc3d31ec0d01d661fb3a4d65248ff"
SRC_URI="https://github.com/develar/app-builder/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz
	https://github.com/darkbasic/gentoo-files/raw/master/${P}-deps.tar.xz"
S="${WORKDIR}/${PN}-${COMMIT_ID}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~ppc64"

BDEPEND="dev-go/go-bindata"

src_compile() {
	emake
}

src_install() {
	dobin dist/${PN}_linux_*/app-builder
}
