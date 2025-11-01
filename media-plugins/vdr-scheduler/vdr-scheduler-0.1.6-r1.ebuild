# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: allows to control externel jobs from within VDR"
HOMEPAGE="http://winni.vdr-developer.org/scheduler/index.html"
SRC_URI="http://winni.vdr-developer.org/scheduler/downloads/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.3.5:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/vdr-2.3.5_compat.patch" )
