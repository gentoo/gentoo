# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/src/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
else
	SCM_ECLASS="git-r3"
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	KEYWORDS=""
fi

inherit cmake-utils multibuild ${SCM_ECLASS}

DESCRIPTION="KDE multimedia API"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="aqua debug designer gstreamer pulseaudio +qt4 qt5 +vlc zeitgeist"

REQUIRED_USE="
	|| ( qt4 qt5 )
	zeitgeist? ( qt4 )
"

RDEPEND="
	!!dev-qt/qtphonon:4
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		designer? ( dev-qt/designer:4 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
	)
	pulseaudio? (
		dev-libs/glib:2
		>=media-sound/pulseaudio-0.9.21[glib]
	)
	zeitgeist? ( dev-libs/libqzeitgeist )
"
DEPEND="${RDEPEND}
	qt4? ( >=dev-util/automoc-0.9.87 )
	virtual/pkgconfig
"
PDEPEND="
	aqua? ( media-libs/phonon-qt7 )
	gstreamer? ( >=media-libs/phonon-gstreamer-4.8.0[qt4?,qt5?] )
	vlc? ( >=media-libs/phonon-vlc-0.8.0[qt4?,qt5?] )
"

PATCHES=( "${FILESDIR}/${PN}-4.7.0-plugin-install.patch" )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=TRUE
			$(cmake-utils_use designer PHONON_BUILD_DESIGNER_PLUGIN)
			$(cmake-utils_use_with pulseaudio GLIB2)
			$(cmake-utils_use_with pulseaudio PulseAudio)
			$(cmake-utils_use_with zeitgeist QZeitgeist)
		)
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

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
