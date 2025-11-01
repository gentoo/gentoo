# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Recover deleted recordings of VDR"
HOMEPAGE="https://phivdr.dyndns.org/vdr/"
SRC_URI="https://phivdr.dyndns.org/vdr/vdr-undelete/vdr-undelete-${PV/_pre/-pre}.tgz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN/vdr-}-${PV/_pre/-pre}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="media-video/vdr:="
RDEPEND="${DEPEND}"
