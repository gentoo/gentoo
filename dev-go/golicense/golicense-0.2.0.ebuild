# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="detect licenses used in Go binaries"
HOMEPAGE="https://github.com/mitchellh/golicense"
SRC_URI="https://github.com/mitchellh/golicense/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

src_compile() {
	ego build
}

src_install() {
	dobin golicense
	dodoc README.md
}
