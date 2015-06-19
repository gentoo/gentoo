# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/bookview/bookview-3.2.1.ebuild,v 1.7 2009/10/17 22:48:11 halcy0n Exp $

inherit eutils

DESCRIPTION="NDTP client written in Tcl/Tk"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/bookview/"
SRC_URI="ftp://ftp.sra.co.jp/pub/net/ndtp/bookview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-lang/tk-8.3"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}/bookview"
	epatch "${FILESDIR}/${P}-gentoo.diff"
}

src_install() {
	make DESTDIR="${D}" install || die

	insinto /etc/X11/app-defaults
	newins "${FILESDIR}/Bookview.ad" Bookview

	dodoc AUTHORS ChangeLog* INSTALL NEWS README
}
