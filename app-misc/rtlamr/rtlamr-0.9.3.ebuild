# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="software defined radio receiver for utility smart meters"
HOMEPAGE="https://github.com/bemasher/rtlamr"
SRC_URI="https://github.com/bemasher/rtlamr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-misc/${PN}/${P}-deps.tar.xz"

LICENSE="AGPL-3 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	ego build .
}

src_test() {
	ego test ./...
}

src_install() {
	dobin ${PN}
	dodoc *.md *.csv
}
