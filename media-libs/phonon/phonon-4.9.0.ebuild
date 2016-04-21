# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	inherit git-r3
fi

inherit cmake-multilib multibuild qmake-utils

DESCRIPTION="KDE multimedia API"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
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
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
PDEPEND="
	aqua? ( media-libs/phonon-qt7 )
	gstreamer? ( >=media-libs/phonon-gstreamer-4.9.0[qt4?,qt5?] )
	vlc? ( >=media-libs/phonon-vlc-0.9.0[qt4?,qt5?] )
"

PATCHES=( "${FILESDIR}/${PN}-4.7.0-plugin-install.patch" )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

multilib_src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=TRUE
		-DWITH_GLIB2=$(usex pulseaudio)
		-DWITH_PulseAudio=$(usex pulseaudio)
		$(multilib_is_native_abi && echo -DWITH_QZeitgeist=$(usex zeitgeist))
	)

	if [[ ${QT_MULTIBUILD_VARIANT} = qt4 ]]; then
		mycmakeargs+=( -DPHONON_BUILD_PHONON4QT5=OFF )
	fi
	if [[ ${QT_MULTIBUILD_VARIANT} = qt5 ]]; then
		mycmakeargs+=( -DPHONON_BUILD_PHONON4QT5=ON )
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
