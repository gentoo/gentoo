# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: will replace the noepg-patch with the new cEpgHandler"
HOMEPAGE="https://github.com/flensrocker/vdr-plugin-noepg"
SRC_URI="https://github.com/flensrocker/vdr-plugin-noepg/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-${VDRPLUGIN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"
