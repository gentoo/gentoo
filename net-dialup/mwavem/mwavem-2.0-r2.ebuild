# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mwavem/mwavem-2.0-r2.ebuild,v 1.2 2015/03/21 21:23:01 jlec Exp $

EAPI="5"

AT_M4DIR="m4"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="User level application for IBM Mwave modem"
HOMEPAGE="http://oss.software.ibm.com/acpmodem/"
SRC_URI="ftp://www-126.ibm.com/pub/acpmodem/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( AUTHORS ChangeLog FAQ NEWS README README.devfs THANKS )

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${P}-glibc-2.10.patch"
)

src_install() {
	autotools-utils_src_install

	dosbin "${FILESDIR}/mwave-dev-handler"

	insinto /etc/devfs.d
	newins "${FILESDIR}/mwave.devfs" mwave

	insinto /etc/modprobe.d
	newins "${FILESDIR}/mwave.modules" mwave.conf

	docinto doc
	dodoc doc/mwave.sgml doc/mwave.txt
	dohtml doc/mwave.html
}

pkg_postinst() {
	if [ -e "${ROOT}/dev/.devfsd" ]; then
		# device node is created by devfs
		ebegin "Restarting devfsd to reread devfs rules"
			killall -HUP devfsd
		eend $?
	else
		elog "Create device node if needed, using command like this:"
		elog "# mknod --mode=0660 \"${ROOT}/dev/modems/mwave\" c 10 219"
	fi
}
