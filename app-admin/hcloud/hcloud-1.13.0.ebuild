# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A command-line interface for Hetzner Cloud"
HOMEPAGE="https://github.com/hetznercloud/cli"
SRC_URI="https://dev.gentoo.org/~ago/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

IUSE=""
DEPEND="dev-lang/go:="
RESTRICT="strip"

src_compile() {
	go build -mod vendor -o ${PN} -ldflags "-w -X github.com/hetznercloud/cli/cli.Version=${PV}-gentoo" ./cmd/${PN} || die "build failed"
}

src_install() {
	dobin ${PN}
}
