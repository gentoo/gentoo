# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

IUSE=""
DESCRIPTION="Shows status of logical drives attached to HP SmartArray controllers"
HOMEPAGE="http://cciss.sourceforge.net/#cciss_utils"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/cciss/${P}.tar.gz"
KEYWORDS="amd64 x86"
SLOT="0"
RDEPEND=""
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "Install failed."
	dodoc AUTHORS ChangeLog NEWS README
	exeinto /etc/cron.daily
	newexe "${FILESDIR}/cciss_vol_status.cron" cciss_vol_status
}
