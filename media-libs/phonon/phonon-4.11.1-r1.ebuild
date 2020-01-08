# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop ecm kde.org

DESCRIPTION="KDE multimedia abstraction library"
HOMEPAGE="https://phonon.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"
fi

LICENSE="|| ( LGPL-2.1 LGPL-3 ) !pulseaudio? ( || ( GPL-2 GPL-3 ) )"
SLOT="0"
IUSE="debug designer gstreamer pulseaudio +vlc"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	designer? ( dev-qt/designer:5 )
	pulseaudio? (
		dev-libs/glib:2
		media-sound/pulseaudio[glib]
	)
"
RDEPEND="${DEPEND}"
PDEPEND="
	gstreamer? ( >=media-libs/phonon-gstreamer-4.9.60 )
	vlc? ( >=media-libs/phonon-vlc-0.9.60 )
"

src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_GLIB2=$(usex !pulseaudio)
		-DCMAKE_DISABLE_FIND_PACKAGE_PulseAudio=$(usex !pulseaudio)
		-DPHONON_BUILD_SETTINGS=ON
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	make_desktop_entry "${PN}settings" \
		"Phonon Audio and Video" preferences-desktop-sound
}
