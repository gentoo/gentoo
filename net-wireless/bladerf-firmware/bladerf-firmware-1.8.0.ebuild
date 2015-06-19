# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bladerf-firmware/bladerf-firmware-1.8.0.ebuild,v 1.2 2015/02/10 16:37:45 zerochaos Exp $

EAPI=5

DESCRIPTION="bladeRF FX3 firmware images"
HOMEPAGE="http://nuand.com/fx3.php"

#firmware is open source, but uses a proprietary toolchain to build
#automated builds from git are available, but likely unneeded
#http://hoopycat.com/bladerf_builds/
SRC_URI="http://nuand.com/fx3/bladeRF_fw_v${PV}.img"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${DISTDIR}"

src_install() {
	insinto /usr/share/Nuand/bladeRF/
	doins bladeRF_fw_v${PV}.img
}

pkg_postinst() {
	elog "Please remember you have to actually flash this onto"
	elog "your bladerf with the following command:"
	elog "bladeRF-cli -f /usr/share/Nuand/bladeRF/bladeRF_fw_v${PV}.img"
}
