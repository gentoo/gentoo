# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: integrates SAT>IP network devices seamlessly into VDR"
HOMEPAGE="http://www.saunalahti.fi/~rahrenbe/vdr/satip/"
SRC_URI="http://www.saunalahti.fi/~rahrenbe/vdr/satip/files/${P}.tgz"

KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="
	>=media-video/vdr-2.2.0
	>=net-misc/curl-7.36
	|| ( dev-libs/tinyxml
		dev-libs/pugixml )
"
RDEPEND="${DEPEND}"
QA_FLAGS_IGNORED="usr/lib/vdr/plugins/libvdr-satip.* usr/lib64/vdr/plugins/libvdr-satip.*"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version "dev-libs/tinyxml" ; then
		sed -e "s:#SATIP_USE_TINYXML:SATIP_USE_TINYXML:" -i Makefile || die "sed failed"
	fi
}
