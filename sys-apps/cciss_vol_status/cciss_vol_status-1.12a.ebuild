# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

IUSE=""
DESCRIPTION="Shows status of logical drives attached to HP SmartArray controllers"
HOMEPAGE="http://cciss.sourceforge.net/#cciss_utils"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/cciss/${P}.tar.gz"
KEYWORDS="amd64 ~ia64 x86"
SLOT="0"
RDEPEND=""
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
	exeinto /etc/cron.hourly
	newexe "${FILESDIR}/cciss_vol_status-r2.cron" cciss_vol_status
}
