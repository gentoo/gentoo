# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://github.com/ethereum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devtools"

# Does all kinds of wonky stuff like connecting to Docker daemon, network activity, ...
RESTRICT+=" test"

src_compile() {
	emake $(usex devtools all geth)
}

src_install() {
	einstalldocs

	dobin build/bin/geth

	if use devtools; then
		dobin build/bin/abidump
		dobin build/bin/abigen
		dobin build/bin/bootnode
		dobin build/bin/checkpoint-admin
		dobin build/bin/clef
		dobin build/bin/devp2p
		dobin build/bin/ethkey
		dobin build/bin/evm
		dobin build/bin/faucet
		dobin build/bin/p2psim
		dobin build/bin/puppeth
		dobin build/bin/rlpdump
	fi
}
