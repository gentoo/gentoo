# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NetWinder ARM bootloader and utilities"
HOMEPAGE="http://www.netwinder.org/"
SRC_URI="http://wh0rd.org/gentoo/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* arm"
RESTRICT="mirror bindist"

S=${WORKDIR}

QA_PREBUILT="
	/sbin/flashwrite
	/usr/sbin/logowrite
	/usr/sbin/logoread"
QA_PRESTRIPPED="${QA_PREBUILT}"

src_install() {
	doman usr/man/man8/flashwrite.8
	rm -r usr/man || die

	insinto /
	doins -r .
}
