# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: allows to control externel jobs from within VDR"
HOMEPAGE="http://winni.vdr-developer.org/scheduler/index.html"
SRC_URI="http://winni.vdr-developer.org/scheduler/downloads/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.3.5"

PATCHES=( "${FILESDIR}/vdr-2.3.5_compat.patch" )
