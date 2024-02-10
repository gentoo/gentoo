# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm kde.org

DESCRIPTION="VLC backend for the Phonon multimedia library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/phonon-backend-vlc/${PV}/phonon-backend-vlc-${PV}.tar.xz"
	S="${WORKDIR}"/phonon-backend-vlc-${PV}
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="+qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	>=media-libs/phonon-4.12.0[qt5=,qt6=]
	media-video/vlc:=[dbus,ogg,vorbis(+)]
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_QT5=$(usex qt5)
		-DPHONON_BUILD_QT6=$(usex qt6)
	)
	ecm_src_configure
}
