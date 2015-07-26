# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bladerf/bladerf-9999.ebuild,v 1.8 2015/07/26 02:56:37 zerochaos Exp $

EAPI=5

inherit cmake-utils udev

DESCRIPTION="Libraries for supporing the BladeRF hardware from Nuand"
HOMEPAGE="http://nuand.com/"

#lib is LGPL and cli tools are GPL
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/${PV}"

#maintainer notes:
#doc use flag, looks like it can't be disabled right now and will
#	always build if pandoc and help2man are installed
#	also ignores when deps are missing and just disables docs
IUSE="doc +tecla"

MY_PN="bladeRF"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Nuand/${MY_PN}.git"
	KEYWORDS=""
else
	MY_PV=${PV/\_/-}
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="https://github.com/Nuand/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

CDEPEND=">=dev-libs/libusb-1.0.16
	tecla? ( dev-libs/libtecla )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"
PDEPEND=">=net-wireless/bladerf-firmware-1.8.0
	>=net-wireless/bladerf-fpga-0.3.4"

src_configure() {
	mycmakeargs=(
		-DVERSION_INFO_OVERRIDE:STRING="${PV}"
		$(cmake-utils_use_enable doc BUILD_DOCUMENTATION)
		$(cmake-utils_use_enable tecla LIBTECLA)
		-DTREAT_WARNINGS_AS_ERRORS=OFF
		-DUDEV_RULES_PATH="$(get_udevdir)"/rules.d
	)
	cmake-utils_src_configure
}
