# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: launch other plugins - even when their menu-entry is hidden"
HOMEPAGE="http://winni.vdr-developer.org/launcher/"
SRC_URI="http://winni.vdr-developer.org/launcher/downloads/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	# 787494
	sed -e "s:MAKEDEP = g++:MAKEDEP = \$(CXX):" -i Makefile || die
}
