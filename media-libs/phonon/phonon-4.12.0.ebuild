# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop ecm kde.org

DESCRIPTION="KDE multimedia abstraction library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="|| ( LGPL-2.1 LGPL-3 ) !pulseaudio? ( || ( GPL-2 GPL-3 ) )"
SLOT="0"
IUSE="designer pulseaudio +qt5 qt6 +vlc"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libpulse[glib]
	)
	qt5? (
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
RDEPEND="${DEPEND}"
BDEPEND="
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
	virtual/pkgconfig
"
PDEPEND="
	vlc? ( >=media-libs/phonon-vlc-0.12.0[qt5?,qt6?] )
"

src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_GLIB2=$(usex !pulseaudio)
		-DCMAKE_DISABLE_FIND_PACKAGE_PulseAudio=$(usex !pulseaudio)
		-DPHONON_BUILD_QT5=$(usex qt5)
		-DPHONON_BUILD_QT6=$(usex qt6)
		-DPHONON_BUILD_SETTINGS=ON
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	make_desktop_entry "${PN}settings" \
		"Phonon Audio and Video" preferences-desktop-sound
}
