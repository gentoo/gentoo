# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vdr-plugin-2

VERSION="1437" # every bump, new Version

DESCRIPTION="VDR Plugin: Shows the least recently used channels"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-zaphistory"
SRC_URI="mirror://vdr-developerorg/${VERSION}/zaphistory-${PV}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${P}-fix-crash-no-info.diff")
