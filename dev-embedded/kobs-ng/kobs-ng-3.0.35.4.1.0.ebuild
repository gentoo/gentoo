# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils versionator

MY_PV="$(get_version_component_range 1-3)-$(get_version_component_range 4-)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="utility to write u-boot images to NAND on Freescale iMX devices"
HOMEPAGE="http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=IMX6_SW"
SRC_URI="http://storage.googleapis.com/chromeos-localmirror/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/kobs-ng-fix-mtd-defines.patch
	epatch "${FILESDIR}"/kobs-ng-fix-open-without-mode.patch
	epatch "${FILESDIR}"/kobs-ng-fix-array-violation.patch
}
