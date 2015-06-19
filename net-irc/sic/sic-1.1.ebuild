# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/sic/sic-1.1.ebuild,v 1.3 2012/08/04 19:07:14 johu Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="An extremly simple IRC client"
HOMEPAGE="http://tools.suckless.org/sic"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

src_prepare() {
	sed -i \
		-e "s/CFLAGS =/CFLAGS +=/g" \
		-e "s/-Os//" \
		-e "s/LDFLAGS =/LDFLAGS +=/" \
		-e "s/-s //g" \
		-e "s/= cc/= $(tc-getCC)/g" \
		config.mk || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
