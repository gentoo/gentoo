# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Recover deleted recordings of VDR"
HOMEPAGE="http://phivdr.dyndns.org/vdr/"
SRC_URI="http://phivdr.dyndns.org/vdr/vdr-undelete/vdr-undelete-2.3.1-pre1.tgz -> ${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="media-video/vdr"

S="${WORKDIR}/undelete-2.3.1-pre1"
