# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

BITCOINCORE_NO_SYSLIBS=1
BITCOINCORE_IUSE=""
inherit bitcoincore

DESCRIPTION="Command-line JSON-RPC client for the communication with the Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_prepare() {
	bitcoincore_prepare
	sed -i 's/bitcoin-tx//' src/Makefile.am || die
	bitcoincore_autoreconf
}

src_configure() {
	bitcoincore_conf \
		--with-utils
}
