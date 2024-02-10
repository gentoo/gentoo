# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: OSD Calculator"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${PN}-0[1].0.1-rc5.tgz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.3.7"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${VDRPLUGIN}-0.0.1-rc5

PATCHES=( "${FILESDIR}/${P}-gcc4.diff" )
