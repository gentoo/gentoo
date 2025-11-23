# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Scan a source directory and report the license"
HOMEPAGE="https://github.com/go-enry/go-license-detector"
SRC_URI="https://github.com/go-enry/go-license-detector/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT ISC"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build ./cmd/license-detector
}

src_install() {
	dobin license-detector
	einstalldocs
}
