# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/sispmctl/sispmctl-2.7.ebuild,v 1.4 2011/03/20 18:28:20 ssuominen Exp $

EAPI=2

DESCRIPTION="GEMBIRD SiS-PM control utility"
HOMEPAGE="http://sispmctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/sispmctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_configure() {
	econf --enable-webless
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README ChangeLog NEWS
}
