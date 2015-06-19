# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpreen/tcpreen-1.4.4.ebuild,v 1.3 2014/07/17 16:33:28 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="TCP network re-engineering tool"
HOMEPAGE="http://www.remlab.net/tcpreen/"
SRC_URI="http://www.remlab.net/files/${PN}/stable/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

DOCS=( AUTHORS NEWS README THANKS TODO )
