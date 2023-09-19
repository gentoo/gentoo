# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
