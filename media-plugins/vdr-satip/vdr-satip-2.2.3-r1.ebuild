# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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

	# c++11 compile fix
	eapply "${FILESDIR}/${P}_c++11.patch"

	if has_version "dev-libs/tinyxml" ; then
		sed -e "s:#SATIP_USE_TINYXML:SATIP_USE_TINYXML:" -i Makefile
	fi
}
