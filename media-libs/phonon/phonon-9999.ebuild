# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon/phonon-9999.ebuild,v 1.29 2015/06/02 15:53:40 johu Exp $

EAPI=5

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/src/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
else
	SCM_ECLASS="git-r3"
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	KEYWORDS=""
fi

inherit multibuild qmake-utils cmake-multilib ${SCM_ECLASS}

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
		dev-qt/qtcore:4[${MULTILIB_USEDEP}]
		dev-qt/qtdbus:4[${MULTILIB_USEDEP}]
		dev-qt/qtgui:4[${MULTILIB_USEDEP}]
		designer? ( dev-qt/designer:4[${MULTILIB_USEDEP}] )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
	)
	pulseaudio? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		>=media-sound/pulseaudio-0.9.21[glib,${MULTILIB_USEDEP}]
	)
	zeitgeist? ( dev-libs/libqzeitgeist )
"
DEPEND="${RDEPEND}
	qt4? ( >=dev-util/automoc-0.9.87 )
	virtual/pkgconfig[${MULTILIB_USEDEP}]
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

multilib_src_configure() {
	local mycmakeargs=(
		-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=TRUE
		$(cmake-utils_use designer PHONON_BUILD_DESIGNER_PLUGIN)
		$(cmake-utils_use_with pulseaudio GLIB2)
		$(cmake-utils_use_with pulseaudio PulseAudio)
		$(multilib_is_native_abi && cmake-utils_use_with zeitgeist QZeitgeist)
		-DQT_QMAKE_EXECUTABLE="$(${QT_MULTIBUILD_VARIANT}_get_bindir)"/qmake
	)
	if [[ ${QT_MULTIBUILD_VARIANT} = qt4 ]]; then
		mycmakeargs+=(-DPHONON_BUILD_PHONON4QT5=OFF)
	fi
	if [[ ${QT_MULTIBUILD_VARIANT} = qt5 ]]; then
		mycmakeargs+=(-DPHONON_BUILD_PHONON4QT5=ON)
	fi
	cmake-utils_src_configure
}

src_configure() {
	myconfigure() {
		local QT_MULTIBUILD_VARIANT=${MULTIBUILD_VARIANT}
		if [[ ${QT_MULTIBUILD_VARIANT} = qt4 ]]; then
			cmake-multilib_src_configure
		elif [[ ${QT_MULTIBUILD_VARIANT} = qt5 ]]; then
			multilib_src_configure
		fi
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	mycompile() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			cmake-multilib_src_compile
		elif [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			cmake-utils_src_compile
		fi
	}
	multibuild_foreach_variant mycompile
}

src_test() {
	mytest() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			cmake-multilib_src_test
		elif [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			cmake-utils_src_test
		fi
	}
	multibuild_foreach_variant mytest
}

src_install() {
	myinstall() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			cmake-multilib_src_install
		elif [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			cmake-utils_src_install
		fi
	}
	multibuild_foreach_variant myinstall
}
