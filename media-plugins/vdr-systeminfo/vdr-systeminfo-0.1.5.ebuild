# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: systeminfo"
HOMEPAGE="https://github.com/FireFlyVDR/vdr-plugin-systeminfo/"
SRC_URI="https://github.com/FireFlyVDR/vdr-plugin-systeminfo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-systeminfo-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr:="
RDEPEND=${DEPEND}"
	app-admin/hddtemp
	sys-apps/lm-sensors"

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/systeminfo/
	insopts -m0755
	doins "${FILESDIR}"/systeminfo.sh
}
