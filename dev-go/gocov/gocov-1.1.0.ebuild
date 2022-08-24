# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Coverage testing tool for The Go Programming Language"
HOMEPAGE="https://github.com/axw/gocov"
SRC_URI="https://github.com/axw/gocov/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o bin/${PN} ./${PN}
}

src_test() {
	ego test ./...
}

src_install() {
	dobin bin/gocov
}
