# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/cec/cec-14.ebuild,v 1.1 2014/11/27 17:22:22 kensington Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Coraid Ethernet Console client"
HOMEPAGE="http://aoetools.sourceforge.net/"
SRC_URI="mirror://sourceforge/aoetools/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin ${PN}
	doman ${PN}.8
	dodoc ${PN}.txt NEWS README
}
