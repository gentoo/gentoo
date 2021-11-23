# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}_$(ver_rs 1- '')"

DESCRIPTION="In-circuit programming (ISP) tool for the NXP microcontrollers"
HOMEPAGE="https://sourceforge.net/projects/lpc21isp/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.97-makefile-tc-vars.patch
)

S="${WORKDIR}"/${MY_P}

src_install() {
	dobin lpc21isp
}
