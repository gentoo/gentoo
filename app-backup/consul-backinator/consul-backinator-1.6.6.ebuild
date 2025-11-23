# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="consul backup and restore utility"
HOMEPAGE="https://github.com/myENA/consul-backinator"

SRC_URI="https://github.com/myENA/consul-backinator/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	CGO_ENABLED=0 ego build -o "${PN}" \
		-ldflags="-X main.appVersion=${PV}" . || die
}

src_install() {
	dobin ${PN}
	dodoc *.md
}
