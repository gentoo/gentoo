# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
