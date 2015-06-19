# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ii/ii-1.6.ebuild,v 1.2 2011/10/25 19:20:07 binki Exp $

EAPI=4

inherit fixheadtails toolchain-funcs

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client"
HOMEPAGE="http://tools.suckless.org/ii/"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i \
		-e "s/CFLAGS      = -g -O0/CFLAGS += /" \
		-e "s/LDFLAGS     =/LDFLAGS +=/" \
		-e /^LIBS/d \
		config.mk || die "sed failed to fix {C,LD}FLAGS"

	ht_fix_file query.sh
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin ii
	newbin query.sh ii-query
	dodoc CHANGES FAQ README
	doman *.1
}
