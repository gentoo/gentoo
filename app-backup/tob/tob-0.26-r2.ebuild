# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A general driver for making and maintaining backups"
HOMEPAGE="http://tinyplanet.ca/projects/tob/"
SRC_URI="http://tinyplanet.ca/projects/tob/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="app-arch/afio"
DEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-no-maketemp-warn.diff \
		"${FILESDIR}"/${P}-nice.patch \
		"${FILESDIR}"/${P}-scsi-tape.diff
	ecvs_clean
}

src_install() {
	dosbin tob
	dodir /var/lib/tob
	insinto /etc/tob
	doins tob.rc
	insinto /etc/tob/volumes
	doins example.*

	dodoc -r README contrib/tobconv doc sample-rc
	doman tob.8
}
