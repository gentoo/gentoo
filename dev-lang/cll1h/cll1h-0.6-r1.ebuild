# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/cll1h/cll1h-0.6-r1.ebuild,v 1.4 2012/12/02 08:53:50 grobian Exp $

EAPI=4

DESCRIPTION="C<<1 programming language system"
HOMEPAGE="http://gpl.arachne.cz/"
SRC_URI="http://gpl.arachne.cz/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="sys-devel/gcc"

src_install() {
	insinto /usr/include
	doins cll1.h
	dodoc cll1.txt
	docinto examples
	dodoc demos/*.c
	docompress -x /usr/share/doc/"${PF}"/examples
}
