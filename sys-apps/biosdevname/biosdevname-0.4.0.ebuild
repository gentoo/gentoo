# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/biosdevname/biosdevname-0.4.0.ebuild,v 1.5 2014/09/19 06:30:09 mgorny Exp $

EAPI=4

DESCRIPTION="Sets BIOS-given device names instead of kernel eth* names"
HOMEPAGE="http://linux.dell.com/biosdevname/"
SRC_URI="http://linux.dell.com/biosdevname/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="virtual/udev"
DEPEND="${CDEPEND}
	sys-apps/pciutils"
RDEPEND="${CDEPEND}"

src_prepare() {
	sed -e 's|/sbin/biosdevname|/usr\0|g' -i "${S}"/biosdevname.rules.in
}

pkg_postinst() {
	elog "To make it working you need to remove"
	elog ""
	elog "  /etc/udev/rules.d/70-persistent-net.rules"
	elog ""
	elog "and then reboot the machine. After reboot ethernet devices names will"
	elog "change to the ones reported by BIOS. For more information you might"
	elog "want to read following document:"
	elog ""
	elog "  http://fedoraproject.org/wiki/Features/ConsistentNetworkDeviceNaming"
	elog ""
	elog "To disable this feature, pass biosdevname=0 to kernel command line."
	elog ""
	elog "If you use Dracut, you might want to enable 'biosdevname' module"
	elog "(in DRACUT_MODULES variable)."
}
