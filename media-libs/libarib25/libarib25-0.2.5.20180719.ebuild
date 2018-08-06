# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="Implementation of ARIB STD-B25"
HOMEPAGE="https://github.com/stz2012/libarib25"

MY_PV="$(ver_rs 3 -)"
SRC_URI="https://github.com/stz2012/libarib25/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-apps/pcsc-lite
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DLDCONFIG_EXECUTABLE=OFF
	)
	cmake-utils_src_configure
}
