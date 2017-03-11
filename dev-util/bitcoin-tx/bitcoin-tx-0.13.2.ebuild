# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

BITCOINCORE_COMMITHASH="0d719145b018e28d48d35c2646a5962b87c60436"
BITCOINCORE_LJR_DATE="20170102"
BITCOINCORE_IUSE="knots"
BITCOINCORE_NEED_LIBSECP256K1=1
BITCOINCORE_NO_DEPEND="libevent"
inherit bitcoincore

DESCRIPTION="Command-line Bitcoin transaction tool"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"

src_configure() {
	bitcoincore_conf \
		--enable-util-tx
}
