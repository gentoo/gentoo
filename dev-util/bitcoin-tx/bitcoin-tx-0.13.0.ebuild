# Copyright 2010-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

BITCOINCORE_COMMITHASH="a402396dce64c42ea73535b7dde4a9164d430438"
BITCOINCORE_LJR_DATE="20160814"
BITCOINCORE_IUSE="ljr"
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
