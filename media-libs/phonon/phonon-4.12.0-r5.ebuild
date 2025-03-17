# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic kde.org

DESCRIPTION="KDE multimedia abstraction library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv ~x86"
fi

LICENSE="|| ( LGPL-2.1 LGPL-3 ) !pulseaudio? ( || ( GPL-2 GPL-3 ) )"
SLOT="0"
IUSE="debug designer minimal pulseaudio"

DEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,widgets]
	designer? ( dev-qt/qttools:6[designer] )
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libpulse[glib]
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
	dev-qt/qttools:6[linguist]
	>=kde-frameworks/extra-cmake-modules-5.115.0:*
	virtual/pkgconfig
"
PDEPEND="!minimal? ( >=media-libs/phonon-vlc-0.12.0-r2 )"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" ) # bug 938315

src_configure() {
	use debug || append-cppflags -DQT_NO_DEBUG

	local mycmakeargs=(
		-DQT_MAJOR_VERSION=6
		-DPHONON_BUILD_QT5=OFF
		-DPHONON_BUILD_QT6=ON
		-DPHONON_BUILD_SETTINGS=ON
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON # ecm.eclass
		-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help" # ecm.eclass
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_GLIB2=$(usex !pulseaudio)
		-DCMAKE_DISABLE_FIND_PACKAGE_PulseAudio=$(usex !pulseaudio)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	make_desktop_entry "${PN}settings" \
		"Phonon Audio and Video" preferences-desktop-sound
}
