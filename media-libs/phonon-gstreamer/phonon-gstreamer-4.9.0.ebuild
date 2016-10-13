# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="phonon-backend-gstreamer"
MY_P=${MY_PN}-${PV}

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_P}.tar.xz"
	KEYWORDS="alpha amd64 ~arm hppa ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	inherit git-r3
fi

inherit cmake-utils multibuild

DESCRIPTION="Phonon GStreamer backend"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="alsa debug +network +qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-plugins/gst-plugins-meta:1.0[alsa?,ogg,vorbis]
	>=media-libs/phonon-4.9.0[qt4?,qt5?]
	qt4? (
		dev-qt/qtcore:4[glib]
		dev-qt/qtgui:4[glib]
		dev-qt/qtopengl:4
		!<dev-qt/qtwebkit-4.10.4:4[gstreamer]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	virtual/opengl
	network? ( media-plugins/gst-plugins-soup:1.0 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=( -DPHONON_BUILD_PHONON4QT5=OFF )
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=( -DPHONON_BUILD_PHONON4QT5=ON )
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
