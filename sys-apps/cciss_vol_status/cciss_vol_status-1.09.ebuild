# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cciss_vol_status/cciss_vol_status-1.09.ebuild,v 1.2 2014/08/10 20:23:26 slyfox Exp $

EAPI=4

IUSE=""
DESCRIPTION="Shows status of logical drives attached to HP SmartArray controllers"
HOMEPAGE="http://cciss.sourceforge.net/#cciss_utils"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/cciss/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
RDEPEND=""
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
