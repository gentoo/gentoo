# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-noepg/vdr-noepg-0.0.4.ebuild,v 1.2 2013/03/31 17:22:46 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: will replace the noepg-patch with the new cEpgHandler"
HOMEPAGE="https://github.com/flensrocker/vdr-plugin-noepg"
SRC_URI="https://github.com/flensrocker/vdr-plugin-noepg/archive/v${PV}.tar.gz
-> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/vdr-plugin-${VDRPLUGIN}-${PV}"
