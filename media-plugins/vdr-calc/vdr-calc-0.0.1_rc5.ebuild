# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: OSD Calculator"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${PN}-0[1].0.1-rc5.tgz"
S=${WORKDIR}/${VDRPLUGIN}-0.0.1-rc5

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gcc4.diff" )
