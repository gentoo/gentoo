# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pvr350/vdr-pvr350-1.7.5.ebuild,v 1.2 2014/03/03 12:01:08 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

VERSION="1657" # every bump, new version

DESCRIPTION="VDR plugin: use a PVR350 as output device"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-pvr350"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="yaepg"

DEPEND=">=media-video/vdr-2
	media-sound/mpg123
	media-sound/twolame
	media-libs/a52dec
	yaepg? ( >=media-video/vdr-2[yaepg] )"
RDEPEND="${DEPEND}"

DEPEND="${DEPEND}
	|| ( >=sys-kernel/linux-headers-2.6.38 )"

S="${WORKDIR}/${P#vdr-}"

pkg_setup() {
	vdr-plugin-2_pkg_setup

	if use yaepg; then
		BUILD_PARAMS="SET_VIDEO_WINDOW=1"
	fi
}

src_prepare() {
	# remove empty language files
	rm po/{ca_ES,cs_CZ,da_DK,el_GR,es_ES,et_EE,fi_FI,fr_FR,hr_HR,hu_HU,nl_NL,nn_NO,pl_PL,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare
}
