# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BITCOINCORE_COMMITHASH="964a185cc83af34587194a6ecda3ed9cf6b49263"
BITCOINCORE_LJR_DATE="20170420"
BITCOINCORE_IUSE="knots"
inherit bash-completion-r1 bitcoincore

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

src_prepare() {
	sed -i 's/have bitcoind &&//;s/^\(complete -F _bitcoind \)bitcoind \(bitcoin-cli\)$/\1\2/' contrib/bitcoind.bash-completion || die
	bitcoincore_src_prepare
}

src_configure() {
	bitcoincore_conf \
		--enable-util-cli
}

src_install() {
	bitcoincore_src_install

	newbashcomp contrib/bitcoind.bash-completion ${PN}
}
