# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Import the EPG of another VDR via vdr-svdrpservice"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-epgsync/ https://vdr.schmirler.de/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-epgsync/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-epgsync-${PV}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"

DEPEND=">=media-video/vdr-2.4"
