# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86"
else
	EGIT_REPO_URI=( "git://anongit.freedesktop.org/gstreamer/${PN}" )
	inherit git-r3
fi

inherit cmake-utils multibuild

DESCRIPTION="C++ bindings for GStreamer with a Qt-style API"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/qt-gstreamer.html"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+qt4 qt5 test"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	dev-libs/glib:2
	>=dev-libs/boost-1.40:=
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdeclarative:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

PATCHES=(
	"${FILESDIR}/${P}-gstreamer15.patch"
	"${FILESDIR}/${P}-boost157.patch"
)

# bug 497880
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usex qt4 4 '') $(usex qt5 5 '') )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Declarative=ON
			-DQTGSTREAMER_EXAMPLES=OFF
			-DQTGSTREAMER_TESTS=$(usex test)
			-DQT_VERSION=${MULTIBUILD_VARIANT}
		)
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
