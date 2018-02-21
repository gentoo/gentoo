# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="phonon-backend-vlc"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
	S="${WORKDIR}/${MY_P}"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	inherit git-r3
fi

inherit cmake-utils multibuild

DESCRIPTION="Phonon VLC backend"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug qt4 +qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	>=media-libs/phonon-4.9.0[qt4=,qt5=]
	>=media-video/vlc-2.0.1:=[dbus,ogg,vorbis]
	qt4? (
		>=dev-qt/qtcore-4.8.7-r2:4
		>=dev-qt/qtgui-4.8.7:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS )

pkg_setup() {
	if use qt4 && [[ $(gcc-major-version) -lt 5 ]] ; then
		ewarn "A GCC version older than 5 was detected. There may be trouble. See also Gentoo bug #595618"
	fi

	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=( -DPHONON_BUILD_PHONON4QT5=OFF )
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=( -DPHONON_BUILD_PHONON4QT5=ON )
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
