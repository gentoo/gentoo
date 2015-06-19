# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bitcoin-tx/bitcoin-tx-9999.ebuild,v 1.2 2015/03/03 23:49:34 blueness Exp $

EAPI=5

BITCOINCORE_NO_SYSLIBS=1
BITCOINCORE_IUSE=""
BITCOINCORE_NEED_LIBSECP256K1=1
inherit bitcoincore

DESCRIPTION="Command-line Bitcoin transaction tool"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_prepare() {
	bitcoincore_prepare
	sed -i 's/bitcoin-cli//' src/Makefile.am
	bitcoincore_autoreconf
}

src_configure() {
	bitcoincore_conf \
		--with-utils
}
