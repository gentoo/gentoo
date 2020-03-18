# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: control an linear or horizon actuator attached trough the parallel port"
HOMEPAGE="http://ventoso.org/luca/vdr/"
SRC_URI="http://ventoso.org/luca/vdr/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=media-video/vdr-1.7.23"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include "${S}/scanner.h"

	sed -i -e "s:SystemValues:SystemValuesSat:" actuator.c
}
