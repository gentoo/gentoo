# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A command-line interface for Hetzner Cloud"
HOMEPAGE="https://github.com/hetznercloud/cli"
SRC_URI="https://dev.gentoo.org/~ago/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
DEPEND="dev-lang/go:="
RESTRICT="strip"
QA_FLAGS_IGNORED=".*"

src_compile() {
	go build -mod vendor -o ${PN} -ldflags "-w -X github.com/hetznercloud/cli/cli.Version=${PV}-gentoo" ./cmd/${PN} || die "build failed"
}

src_test() {
	# For upstream a simple test is run 'hcloud version'
	./hcloud version
	if [[ $? -ne 0 ]]
	then
		die "Test failed"
	fi
}

src_install() {
	dobin ${PN}
}
