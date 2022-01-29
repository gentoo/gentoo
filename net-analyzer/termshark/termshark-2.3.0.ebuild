# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A terminal UI for tshark, inspired by Wireshark"
HOMEPAGE="https://termshark.io/"
SRC_URI="https://github.com/gcla/termshark/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD-2 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

# termshark doesn't link against wireshark. It reads data via IPC during
# runtime.
RDEPEND="
	net-analyzer/wireshark[dumpcap,pcap,tshark]
"

src_compile() {
	ego build ./...
}

src_test() {
	ego test ./...
}

src_install() {
	GOBIN="${S}/bin" ego install ./...

	dobin bin/${PN}
	dodoc README.md
	dodoc docs/*
}
