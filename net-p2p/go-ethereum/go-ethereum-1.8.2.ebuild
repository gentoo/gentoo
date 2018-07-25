# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base

DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://github.com/ethereum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devtools opencl"

DEPEND="dev-lang/go:=
	opencl? ( virtual/opencl )
"
RDEPEND="${DEPEND}"

src_compile() {
	use opencl && export GO_OPENCL=true

	emake $(usex devtools all geth)
}

src_install() {
	einstalldocs

	dobin build/bin/geth
	if use devtools; then
		dobin build/bin/abigen
		dobin build/bin/bootnode
		dobin build/bin/evm
		dobin build/bin/p2psim
		dobin build/bin/puppeth
		dobin build/bin/rlpdump
		dobin build/bin/swarm
		dobin build/bin/wnode
	fi
}
