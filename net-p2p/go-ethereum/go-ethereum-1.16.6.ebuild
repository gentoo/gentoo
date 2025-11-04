# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module

DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://github.com/ethereum/go-ethereum/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/pva/pva.github.io/releases/download/v1.0/${P}-deps.tar.xz"

LICENSE="GPL-3+ LGPL-3+ MIT || ( BSD GPL-2 ) BSD-2 LGPL-2.1+ Apache-2.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devtools"

# Does all kinds of wonky stuff like connecting to Docker daemon, network activity, ...
RESTRICT+=" test"

PATCHES=( "${FILESDIR}/go-ethereum-1.16.6-dont-strip.patch" )

src_compile() {
	go-env_set_compile_environment
	export DEBUG_SYMBOLS=1
	emake $(usex devtools all geth)
}

src_install() {
	einstalldocs

	dobin build/bin/geth

	# TODO: replace with wildcard
	if use devtools; then
		dobin build/bin/abidump
		dobin build/bin/abigen
		dobin build/bin/blsync
		dobin build/bin/clef
		dobin build/bin/devp2p
		dobin build/bin/era
		dobin build/bin/ethkey
		dobin build/bin/evm
		dobin build/bin/rlpdump
	fi
}
