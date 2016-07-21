# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

AT_M4DIR="m4"

inherit autotools eutils

DESCRIPTION="User level application for IBM Mwave modem"
HOMEPAGE="http://oss.software.ibm.com/acpmodem/"
SRC_URI="ftp://www-126.ibm.com/pub/acpmodem/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-glibc-2.10.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dosbin "${FILESDIR}/mwave-dev-handler"

	insinto /etc/devfs.d
	newins "${FILESDIR}/mwave.devfs" mwave

	insinto /etc/modprobe.d
	newins "${FILESDIR}/mwave.modules" mwave.conf

	dodoc AUTHORS ChangeLog FAQ NEWS README README.devfs THANKS
	docinto doc
	dodoc doc/mwave.sgml doc/mwave.txt
	dohtml doc/mwave.html
}

pkg_postinst() {
	# Below is to get /etc/modules.d/mwave loaded into /etc/modules.conf
	if [ "$ROOT" = "/" ]; then
		[ -x /sbin/update-modules ] && /sbin/update-modules || /sbin/modules-update
	fi

	if [ -e "${ROOT}/dev/.devfsd" ]; then
		# device node is created by devfs
		ebegin "Restarting devfsd to reread devfs rules"
			killall -HUP devfsd
		eend $?
	elif [ -e "${ROOT}/dev/.udev" ]; then
		#the device should be created by udev
		ebegin "Restarting udev to reread udev rules"
			udevadm control --reload-rules
		eend $?
	else
		[ ! -d "${ROOT}/dev/modem" ] && mkdir --mode=0755 "${ROOT}/dev/modems"
		mknod --mode=0660 "${ROOT}/dev/modems/mwave" c 10 219
	fi
}
