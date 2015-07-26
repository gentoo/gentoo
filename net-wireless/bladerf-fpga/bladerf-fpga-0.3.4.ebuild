# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bladerf-fpga/bladerf-fpga-0.3.4.ebuild,v 1.1 2015/07/26 02:55:36 zerochaos Exp $

EAPI=5

DESCRIPTION="bladeRF FPGA bitstreams"
HOMEPAGE="http://nuand.com/fpga.php"

#fpga code is open source, but uses a proprietary toolchain to build
#automated builds from git are available, but likely unneeded
#http://hoopycat.com/bladerf_builds/
SRC_URI="x40? ( http://nuand.com/fpga/v${PV}/hostedx40.rbf -> hostedx40-${PV}.rbf )
		x115? ( http://nuand.com/fpga/v${PV}/hostedx115.rbf -> hostedx115-${PV}.rbf )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+x40 +x115"

DEPEND=""
RDEPEND="${DEPEND}"

S="${DISTDIR}"

src_install() {
	insinto /usr/share/Nuand/bladeRF/
	use x40 && newins hostedx40-${PV}.rbf hostedx40.rbf
	use x115 && newins hostedx115-${PV}.rbf hostedx115.rbf
}
