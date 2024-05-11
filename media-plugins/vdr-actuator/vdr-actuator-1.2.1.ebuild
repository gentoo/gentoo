# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: control a horz. or vert. actuator attached through the parallel port"
HOMEPAGE="https://ventoso.org/luca/vdr/"
SRC_URI="https://ventoso.org/luca/vdr/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

# this plugin version is intended to use with media-video/vdr-2.2
DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include "${S}/scanner.h"

	sed -i -e "s:SystemValues:SystemValuesSat:" actuator.c || die
}
