# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Simple, lightweight, dependable CLI for ZooKeeper"
HOMEPAGE="https://github.com/kt315/zookeepercli"
SRC_URI="https://github.com/kt315/zookeepercli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
LICENSE+=" BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -ldflags "-X main.Version=${PV}" -o ./bin/${PN}
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
}
