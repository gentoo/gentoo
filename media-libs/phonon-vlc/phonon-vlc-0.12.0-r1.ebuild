# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic kde.org multibuild

DESCRIPTION="VLC backend for the Phonon multimedia library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/phonon-backend-vlc/${PV}/phonon-backend-vlc-${PV}.tar.xz"
	S="${WORKDIR}"/phonon-backend-vlc-${PV}
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug +qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	>=media-libs/phonon-4.12.0[qt5=,qt6=]
	media-video/vlc:=[dbus,ogg,vorbis(+)]
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/libpcre2:*
	>=kde-frameworks/extra-cmake-modules-5.115.0:*
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
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
		)

		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			mycmakeargs+=( -DPHONON_BUILD_QT5=OFF )
		else
			mycmakeargs+=( -DPHONON_BUILD_QT6=OFF )
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
}
