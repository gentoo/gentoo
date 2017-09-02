# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BITCOINCORE_COMMITHASH="fc61c8322bd7288f7546d18ad04c36c345be13cd"
BITCOINCORE_LJR_DATE="20170618"
BITCOINCORE_IUSE="knots"
BITCOINCORE_NEED_LIBSECP256K1=1
BITCOINCORE_NO_DEPEND="libevent"
inherit bitcoincore

DESCRIPTION="Command-line Bitcoin transaction tool"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

src_configure() {
	bitcoincore_conf \
		--enable-util-tx
}
