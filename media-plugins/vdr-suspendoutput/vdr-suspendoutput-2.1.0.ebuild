# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Show still image instead of live tv to save cpu"
HOMEPAGE="https://phivdr.dyndns.org/vdr/vdr-suspendoutput/"
SRC_URI="https://phivdr.dyndns.org/vdr/vdr-suspendoutput/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_gcc-fix.patch" )
