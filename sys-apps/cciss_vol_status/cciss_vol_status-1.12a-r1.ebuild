# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shows status of logical drives attached to HP SmartArray controllers"
HOMEPAGE="https://cciss.sourceforge.net/#cciss_utils"
SRC_URI="mirror://sourceforge/cciss/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="amd64 ~ia64 ~x86"
SLOT="0"

src_install() {
	default
	exeinto /etc/cron.hourly
	newexe "${FILESDIR}/cciss_vol_status-r2.cron" cciss_vol_status
}
