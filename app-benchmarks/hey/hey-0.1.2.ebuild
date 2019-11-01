# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="HTTP load generator, ApacheBench (ab) replacement, formerly known as rakyll/boom"
HOMEPAGE="https://github.com/rakyll/hey"
SRC_URI="https://github.com/rakyll/hey/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	go build -o ./bin/${PN} || die
}

src_install() {
	dobin ./bin/${PN}
	dodoc README.md
}
