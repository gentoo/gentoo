# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	inherit git-r3
fi

inherit cmake-utils qmake-utils

DESCRIPTION="KDE multimedia API"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug designer gstreamer pulseaudio +vlc"

RDEPEND="
	!!dev-qt/qtphonon:4
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	designer? ( dev-qt/designer:5 )
	pulseaudio? (
		dev-libs/glib:2
		>=media-sound/pulseaudio-0.9.21[glib]
	)
"
DEPEND="${RDEPEND}
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig
"
PDEPEND="
	gstreamer? ( >=media-libs/phonon-gstreamer-4.9.0[qt5(+)] )
	vlc? ( >=media-libs/phonon-vlc-0.9.0[qt5(+)] )
"

src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_PHONON4QT5=ON
		-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=TRUE
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Declarative=ON
		-DWITH_GLIB2=$(usex pulseaudio)
		-DWITH_PulseAudio=$(usex pulseaudio)
		-DQT_QMAKE_EXECUTABLE="$(qt5_get_bindir)"/qmake
	)
	cmake-utils_src_configure
}
