# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bitcoin-tx/bitcoin-tx-0.11.0.ebuild,v 1.1 2015/07/17 22:38:10 blueness Exp $

EAPI=5

BITCOINCORE_COMMITHASH="d26f951802c762de04fb68e1a112d611929920ba"
BITCOINCORE_LJR_DATE="20150711"
BITCOINCORE_IUSE=""
BITCOINCORE_NEED_LIBSECP256K1=1
inherit bitcoincore

DESCRIPTION="Command-line Bitcoin transaction tool"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

src_configure() {
	bitcoincore_conf \
		--enable-util-tx
}
