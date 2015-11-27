# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

BITCOINCORE_COMMITHASH="7e278929df53e1fb4191bc5ba3176a177ce718bf"
BITCOINCORE_LJR_DATE="20151118"
BITCOINCORE_IUSE="ljr"
inherit bash-completion-r1 bitcoincore

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

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

	doman contrib/debian/manpages/bitcoin-cli.1

	newbashcomp contrib/bitcoind.bash-completion ${PN}
}
