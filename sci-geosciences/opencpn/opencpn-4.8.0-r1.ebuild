# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WX_GTK_VER="3.0"
inherit cmake-utils wxwidgets

DOC_VERSION="4.1.1329.1"

DESCRIPTION="a free, open source software for marine navigation"
HOMEPAGE="https://opencpn.org/"
SRC_URI="https://github.com/OpenCPN/OpenCPN/archive/v${PV}.tar.gz -> ${P}.tar.gz
doc? ( https://launchpad.net/~opencpn/+archive/ubuntu/${PN}/+files/${PN}-doc_${DOC_VERSION}.orig.tar.xz )
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
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	gps? ( sci-geosciences/gpsd )
	!sci-geosciences/opencpn-plugin-wmm
"
DEPEND="${RDEPEND}
	sys-devel/gettext"

S="${WORKDIR}/OpenCPN-${PV}"

src_configure() {
	need-wxwidgets unicode
	local mycmakeargs=(
		$(cmake-utils_use_use gps GPSD)
		-DUSE_S57=ON
		-DUSE_GARMINHOST=ON
		-DBUNDLE_GSHHS=CRUDE
		-DBUNDLE_TCDATA=ON
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
		einfo "Documentation is available at file:///usr/share/doc/${PF}/html/help_en_US.html"
	fi
}
