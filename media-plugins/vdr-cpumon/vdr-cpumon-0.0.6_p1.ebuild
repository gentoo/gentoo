# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Show cpu-usage on OSD"
HOMEPAGE="http://www.christianglass.de/cpumon/"
SRC_URI="http://www.christianglass.de/cpumon//${PN}-0.0.6a.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.44"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${VDRPLUGIN}-0.0.6a"
