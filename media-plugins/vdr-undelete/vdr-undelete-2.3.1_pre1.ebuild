# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Recover deleted recordings of VDR"
HOMEPAGE="http://phivdr.dyndns.org/vdr/"
SRC_URI="http://phivdr.dyndns.org/vdr/vdr-undelete/vdr-undelete-${PV/_pre/-pre}.tgz -> ${P}.tgz"
S="${WORKDIR}"/${PN/vdr-}-${PV/_pre/-pre}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"

DEPEND="media-video/vdr"
