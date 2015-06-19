# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libbitcoinconsensus/libbitcoinconsensus-0.10.1.ebuild,v 1.1 2015/05/27 00:55:08 blueness Exp $

EAPI=5

BITCOINCORE_COMMITHASH="d8ac90184254fea3a7f4991fd0529dfbd750aea0"
BITCOINCORE_LJR_DATE="20150428"
BITCOINCORE_IUSE="test"
inherit bitcoincore eutils

DESCRIPTION="Bitcoin Core consensus library"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

src_configure() {
	bitcoincore_conf \
		--with-libs
}

src_install() {
	bitcoincore_src_install
	prune_libtool_files
}
