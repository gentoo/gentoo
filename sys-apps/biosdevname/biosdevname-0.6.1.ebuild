# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit udev

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
	sed -i -e 's|/sbin/biosdevname|/usr\0|g' biosdevname.rules.in || die
	sed -i -e "/RULEDEST/s:/lib/udev:$(get_udevdir):" configure{,.ac} || die
}
