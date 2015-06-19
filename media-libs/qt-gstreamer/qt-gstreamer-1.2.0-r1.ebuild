# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/qt-gstreamer/qt-gstreamer-1.2.0-r1.ebuild,v 1.3 2015/05/30 11:39:48 johu Exp $

EAPI=5

if [[ ${PV} != *9999* ]]; then
	SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI=( "git://anongit.freedesktop.org/gstreamer/${PN}" )
	KEYWORDS=""
fi

inherit cmake-utils ${GIT_ECLASS} multibuild

DESCRIPTION="QtGStreamer provides C++ bindings for GStreamer with a Qt-style API"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/qt-gstreamer.html"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+qt4 qt5 test"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	dev-libs/glib:2
	>=dev-libs/boost-1.40:=
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
		dev-qt/qtquick1:5
		dev-qt/qtwidgets:5
	)
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
DEPEND="
	${RDEPEND}
	test? (
		qt4? (
			dev-qt/qttest:4
		)
	)
"

PATCHES=( "${FILESDIR}/${P}-boost157.patch" )

# bug 497880
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usex qt4 4 '') $(usex qt5 5 '') )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DQTGSTREAMER_EXAMPLES=OFF
			$(cmake-utils_use test QTGSTREAMER_TESTS)
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
