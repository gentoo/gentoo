# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="bladeRF FPGA bitstreams"
HOMEPAGE="http://nuand.com/fpga.php"

#fpga code is open source, but uses a proprietary toolchain to build
#automated builds from git are available, but likely unneeded
#http://hoopycat.com/bladerf_builds/
SRC_URI="xA4? ( http://nuand.com/fpga/v${PV}/hostedxA4.rbf -> hostedxA4-${PV}.rbf )
		xA9? ( http://nuand.com/fpga/v${PV}/hostedxA9.rbf -> hostedxA9-${PV}.rbf )
		x40? ( http://nuand.com/fpga/v${PV}/hostedx40.rbf -> hostedx40-${PV}.rbf )
		x115? ( http://nuand.com/fpga/v${PV}/hostedx115.rbf -> hostedx115-${PV}.rbf )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="+xA4 +xA9 +x40 +x115"

DEPEND=""
RDEPEND="${DEPEND}"

S="${DISTDIR}"

src_unpack() {
	true
}

src_install() {
	insinto /usr/share/Nuand/bladeRF/
	use xA4 && newins hostedxA4-${PV}.rbf hostedxA4.rbf
	use xA9 && newins hostedxA9-${PV}.rbf hostedxA9.rbf
	use x40 && newins hostedx40-${PV}.rbf hostedx40.rbf
	use x115 && newins hostedx115-${PV}.rbf hostedx115.rbf
}
