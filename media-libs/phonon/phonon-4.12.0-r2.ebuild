# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic kde.org multibuild

DESCRIPTION="KDE multimedia abstraction library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="|| ( LGPL-2.1 LGPL-3 ) !pulseaudio? ( || ( GPL-2 GPL-3 ) )"
SLOT="0"
IUSE="debug designer pulseaudio +qt5 qt6 +vlc"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libpulse[glib]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
	)
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[gui,widgets]
		designer? ( dev-qt/qttools:6[designer] )
	)
"
RDEPEND="${DEPEND}
	!media-libs/phonon-gstreamer
	|| (
		kde-frameworks/breeze-icons:*
		kde-frameworks/oxygen-icons:*
	)
"
BDEPEND="
	dev-libs/libpcre2:*
	>=kde-frameworks/extra-cmake-modules-5.115.0:*
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"
PDEPEND="
	vlc? ( >=media-libs/phonon-vlc-0.12.0[qt5?,qt6?] )
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	use debug || append-cppflags -DQT_NO_DEBUG

	myconfigure() {
		local mycmakeargs=(
			-DQT_MAJOR_VERSION=${MULTIBUILD_VARIANT/qt/}
			-DPHONON_BUILD_${MULTIBUILD_VARIANT^^}=ON
			-DKDE_INSTALL_USE_QT_SYS_PATHS=ON # ecm.eclass
			-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help" # ecm.eclass
			-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
			-DCMAKE_DISABLE_FIND_PACKAGE_GLIB2=$(usex !pulseaudio)
			-DCMAKE_DISABLE_FIND_PACKAGE_PulseAudio=$(usex !pulseaudio)
		)

		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			mycmakeargs+=(
				-DPHONON_BUILD_QT5=OFF
				-DPHONON_BUILD_SETTINGS=ON
			)
		else
			mycmakeargs+=(
				-DPHONON_BUILD_QT6=OFF
				-DPHONON_BUILD_SETTINGS=$(usex !qt6)
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	make_desktop_entry "${PN}settings" \
		"Phonon Audio and Video" preferences-desktop-sound
}
