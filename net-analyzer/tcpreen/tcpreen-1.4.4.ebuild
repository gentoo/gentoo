# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

DESCRIPTION="TCP network re-engineering tool"
HOMEPAGE="http://www.remlab.net/tcpreen/"
SRC_URI="http://www.remlab.net/files/${PN}/stable/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

DOCS=( AUTHORS NEWS README THANKS TODO )

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake AR="$(tc-getAR)"
}
