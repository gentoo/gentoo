# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="bladeRF FPGA bitstreams"
HOMEPAGE="https://nuand.com/fpga.php"

#fpga code is open source, but uses a proprietary toolchain to build
#automated builds from git are available, but likely unneeded
#http://hoopycat.com/bladerf_builds/
wlan_latest="0.15.3"
SRC_URI="wlanxA9? ( https://www.nuand.com/fpga/v${wlan_latest}/wlanxA9.rbf -> wlanxA9-${wlan_latest}.rbf )
		xA4? ( https://nuand.com/fpga/v${PV}/hostedxA4.rbf -> hostedxA4-${PV}.rbf )
		xA5? ( https://nuand.com/fpga/v${PV}/hostedxA5.rbf -> hostedxA5-${PV}.rbf )
		xA9? ( https://nuand.com/fpga/v${PV}/hostedxA9.rbf -> hostedxA9-${PV}.rbf )
		x40? ( https://nuand.com/fpga/v${PV}/hostedx40.rbf -> hostedx40-${PV}.rbf )
		x115? ( https://nuand.com/fpga/v${PV}/hostedx115.rbf -> hostedx115-${PV}.rbf )"

S="${DISTDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv x86"
IUSE="wlanxA9 +xA4 xA5 +xA9 +x40 +x115"
REQUIRED_USE="|| ( wlanxA9 xA4 xA5 xA9 x40 x115 )"

src_unpack() {
	true
}

src_install() {
	insinto /usr/share/Nuand/bladeRF/
	use wlanxA9 && newins wlanxA9-${PV}.rbf wlanxA9.rbf
	use xA4 && newins hostedxA4-${PV}.rbf hostedxA4.rbf
	use xA5 && newins hostedxA5-${PV}.rbf hostedxA5.rbf
	use xA9 && newins hostedxA9-${PV}.rbf hostedxA9.rbf
	use x40 && newins hostedx40-${PV}.rbf hostedx40.rbf
	use x115 && newins hostedx115-${PV}.rbf hostedx115.rbf
}
