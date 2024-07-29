# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Go binary license checker"
HOMEPAGE="https://github.com/uw-labs/lichen"
SRC_URI="https://github.com/uw-labs/lichen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o ${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs
}
