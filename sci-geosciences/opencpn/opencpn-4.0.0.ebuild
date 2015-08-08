# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# TODO: add plugins

## wmm_pi, World Magnetic Model (https://github.com/nohal/wmm_pi, GPL-2+)
#WMM_PLUGIN_PV="1.0"
#WMM_PLUGIN_PN="wmm_pi"
#WMM_PLUGIN_P="${WMM_PLUGIN_PN}-${WMM_PLUGIN_PV}"
#WMM_PLUGIN_URI="https://github.com/nohal/${WMM_PLUGIN_PN}/archive/${WMM_PLUGIN_PN}-v${WMM_PLUGIN_PV}.tar.gz"
#WMM_PLUGIN_WD="${WORKDIR}/plugins/${WMM_PLUGIN_PN}"

WX_GTK_VER="2.8"
inherit cmake-utils wxwidgets

DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="http://opencpn.org/"
SRC_URI="https://github.com/OpenCPN/OpenCPN/archive/v${PV}.tar.gz -> ${P}.tar.gz
doc? ( https://launchpad.net/~opencpn/+archive/ubuntu/${PN}/+files/${PN}-doc_${PV}.orig.tar.xz )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gps opengl"

RDEPEND="
	app-arch/bzip2
	dev-libs/tinyxml
	media-libs/freetype:2
	media-libs/portaudio
	sys-libs/zlib
	opengl? ( virtual/opengl )
	x11-libs/gtk+:2
	x11-libs/wxGTK:2.8[X]
	gps? ( >=sci-geosciences/gpsd-2.96-r1 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext"

S="${WORKDIR}/OpenCPN-${PV}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use gps GPSD)
		-DUSE_S57=ON
		-DUSE_GARMINHOST=ON
	)

	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		dohtml -r "${S}"/../${PN}/doc/*
	fi
	cmake-utils_src_install
}

pkg_postinst() {
	if use doc; then
		einfo "Documentation is available at file:///usr/share/doc/${P}/html/help_en_US.html"
	fi
}
