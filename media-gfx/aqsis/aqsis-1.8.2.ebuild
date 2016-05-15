# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="Open source RenderMan-compliant 3D rendering solution"
HOMEPAGE="http://www.aqsis.org"
SRC_URI="mirror://sourceforge/aqsis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="png qt4"

# OpenEXR currently can not be optional dependency, despite build system options
RDEPEND="
	dev-libs/boost:=
	dev-libs/tinyxml
	media-libs/tiff:0
	sys-libs/zlib
	media-libs/openexr:=
	png? ( media-libs/libpng:0= )
	qt4? ( dev-qt/qtgui:4 )
"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	sys-devel/bison
	sys-devel/flex
"

DOCS=( AUTHORS INSTALL README )
PATCHES=(
	"${FILESDIR}/${P}-openexr-compat.patch"
	"${FILESDIR}/${P}-unbundle-tinyxml.patch"
	"${FILESDIR}/${P}-pfto-boost-1.59.patch"
	"${FILESDIR}/${P}-boost-join-moc.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use png AQSIS_USE_PNG)
		$(cmake-utils_use qt4 AQSIS_USE_QT)
		-DAQSIS_ENABLE_DOCS=OFF
		-DAQSIS_USE_EXTERNAL_TINYXML=ON
		-DAQSIS_USE_OPENEXR=ON
		-DAQSIS_USE_RPATH=OFF
		-DLIBDIR="$(get_libdir)"
		-DSYSCONFDIR="/etc"
	)
	cmake-utils_src_configure
}

src_install() {
	newdoc "release-notes/1.8/summary-1.8.0.txt" ReleaseNotes
	cmake-utils_src_install
}
