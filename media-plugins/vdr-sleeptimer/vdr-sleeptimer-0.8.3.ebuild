# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Sleeptimer"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-sleeptimer/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-sleeptimer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-sleeptimer-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr:="
RDEPEND="${DEPEND}"
