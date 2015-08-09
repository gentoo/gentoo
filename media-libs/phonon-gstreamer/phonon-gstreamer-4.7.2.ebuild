# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

[[ ${PV} == *9999 ]] && git_eclass="git-r3"
EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )

MY_PN="phonon-backend-gstreamer"
MY_P=${MY_PN}-${PV}

inherit cmake-utils multibuild ${git_eclass}

DESCRIPTION="Phonon GStreamer backend"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon/phonon-gstreamer"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/src/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 arm hppa ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
fi
SLOT="0"
IUSE="alsa debug +network +qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	dev-libs/glib:2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-plugins/gst-plugins-meta:0.10[alsa?,ogg,vorbis]
	>=media-libs/phonon-4.7.0[qt4?,qt5?]
	qt4? (
		dev-qt/qtcore:4[glib]
		dev-qt/qtgui:4[glib]
		dev-qt/qtopengl:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	virtual/opengl
	network? ( media-plugins/gst-plugins-soup:0.10 )
"
DEPEND="${RDEPEND}
	qt4? ( >=dev-util/automoc-0.9.87 )
	virtual/pkgconfig
"

[[ ${PV} == 9999 ]] || S=${WORKDIR}/${MY_P}

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	if use qt4; then
		MULTIBUILD_VARIANTS+=(qt4)
	fi
	if use qt5; then
		MULTIBUILD_VARIANTS+=(qt5)
	fi
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=(-DPHONON_BUILD_PHONON4QT5=OFF)
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(-DPHONON_BUILD_PHONON4QT5=ON)
		fi
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

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}
