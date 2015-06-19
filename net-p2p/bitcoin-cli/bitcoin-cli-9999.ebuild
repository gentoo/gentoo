# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitcoin-cli/bitcoin-cli-9999.ebuild,v 1.4 2015/03/03 23:59:21 blueness Exp $

EAPI=5

BITCOINCORE_NO_SYSLIBS=1
BITCOINCORE_IUSE=""
inherit bitcoincore

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_prepare() {
	bitcoincore_prepare
	sed -i 's/bitcoin-tx//' src/Makefile.am
	bitcoincore_autoreconf
}

src_configure() {
	bitcoincore_conf \
		--with-utils
}
