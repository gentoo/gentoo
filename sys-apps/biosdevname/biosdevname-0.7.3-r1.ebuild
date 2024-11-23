# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

DESCRIPTION="Sets BIOS-given device names instead of kernel eth* names"
HOMEPAGE="
	https://linux.dell.com/biosdevname/
	https://github.com/dell/biosdevname
"
SRC_URI="https://github.com/dell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/udev
	sys-apps/pciutils
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e 's|/sbin/biosdevname|/usr\0|g' biosdevname.rules.in || die
	sed -i -e "/RULEDEST/s:/lib/udev:$(get_udevdir):" configure.ac || die

	eautoreconf
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
