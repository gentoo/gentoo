# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 1-3)-$(ver_cut 4-)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Utility to write u-boot images to NAND on Freescale iMX devices"
HOMEPAGE="http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=IMX6_SW"
SRC_URI="http://storage.googleapis.com/chromeos-localmirror/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-mtd-defines.patch
	"${FILESDIR}"/${PN}-fix-open-without-mode.patch
	"${FILESDIR}"/${PN}-fix-array-violation.patch
	"${FILESDIR}"/${PN}-fix-stdint.patch
)
