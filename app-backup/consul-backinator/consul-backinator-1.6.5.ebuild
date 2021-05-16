# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/myENA/consul-backinator
RESTRICT="strip"

DESCRIPTION="consul backup and restore utility"
HOMEPAGE="https://github.com/myENA/consul-backinator"
SRC_URI="https://github.com/myENA/consul-backinator/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go:="

src_prepare() {
	default
	mv ../vendor .
	echo module ${EGO_PN} > go.mod || die "Unable to create go.mod"
}

src_compile() {
	CGO_ENABLED=0 go build -mod vendor -o "${PN}" -v -x \
		-ldflags="-X main.appVersion=${PV} -s -w" || die
}

src_install() {
	dobin ${PN}
	dodoc *.md
}
