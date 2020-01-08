# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="Sets BIOS-given device names instead of kernel eth* names"
HOMEPAGE="http://linux.dell.com/biosdevname/"
SRC_URI="https://github.com/dell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="virtual/udev"
DEPEND="${CDEPEND}
	sys-apps/pciutils"
RDEPEND="${CDEPEND}"

src_prepare() {
	default

	sed -i -e 's|/sbin/biosdevname|/usr\0|g' biosdevname.rules.in || die
	sed -i -e "/RULEDEST/s:/lib/udev:$(get_udevdir):" configure.ac || die

	./autogen.sh --no-configure || die
}
