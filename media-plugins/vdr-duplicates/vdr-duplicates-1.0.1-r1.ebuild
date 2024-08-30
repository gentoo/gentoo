# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: show duplicated records"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-duplicates"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-duplicates/archive/refs/tags/${PV}.tar.gz ->  ${P}.tgz"
S="${WORKDIR}/vdr-plugin-duplicates-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"
