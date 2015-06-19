# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-satip/vdr-satip-2.2.0.ebuild,v 1.1 2015/03/30 12:15:01 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: integrates SAT>IP network devices seamlessly into VDR"
HOMEPAGE="http://www.saunalahti.fi/~rahrenbe/vdr/satip/"
SRC_URI="http://www.saunalahti.fi/~rahrenbe/vdr/satip/files/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0
		>=net-misc/curl-7.36
		|| ( dev-libs/tinyxml
			dev-libs/pugixml )"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version "dev-libs/tinyxml" ; then
		sed -e "s:#SATIP_USE_TINYXML:SATIP_USE_TINYXML:" -i Makefile
		#BUILD_PARAMS+=" SATIP_USE_TINYXML = 1 "
	fi
}
