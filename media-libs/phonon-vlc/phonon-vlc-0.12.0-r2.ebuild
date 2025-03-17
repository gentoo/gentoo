# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic kde.org

DESCRIPTION="VLC backend for the Phonon multimedia library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/phonon-backend-vlc/${PV}/phonon-backend-vlc-${PV}.tar.xz"
	S="${WORKDIR}"/phonon-backend-vlc-${PV}
	KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	>=media-libs/phonon-4.12.0-r5
	media-video/vlc:=[dbus,ogg,vorbis(+)]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/libpcre2:*
	dev-qt/qttools:6[linguist]
	>=kde-frameworks/extra-cmake-modules-5.115.0:*
	virtual/pkgconfig
"

src_configure() {
	use debug || append-cppflags -DQT_NO_DEBUG

	local mycmakeargs=(
		-DQT_MAJOR_VERSION=6
		-DPHONON_BUILD_QT5=OFF
		-DPHONON_BUILD_QT6=ON
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON # ecm.eclass
		-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help" # ecm.eclass
	)
	cmake_src_configure
}
