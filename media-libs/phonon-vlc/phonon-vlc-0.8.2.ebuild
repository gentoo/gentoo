# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon-vlc/phonon-vlc-0.8.2.ebuild,v 1.2 2015/01/30 21:41:38 johu Exp $

EAPI=5

MY_PN="phonon-backend-vlc"
MY_P="${MY_PN}-${PV}"
EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
[[ ${PV} == 9999 ]] && git_eclass=git-r3
inherit cmake-utils multibuild ${git_eclass}
unset git_eclass

DESCRIPTION="Phonon VLC backend"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon/phonon-vlc"
[[ ${PV} == 9999 ]] || SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/src/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd"

SLOT="0"
IUSE="debug +qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	>=media-libs/phonon-4.8.0[qt4=,qt5=]
	>=media-video/vlc-2.0.1:=[dbus,ogg,vorbis]
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	qt4? ( >=dev-util/automoc-0.9.87 )
"

[[ ${PV} == 9999 ]] || S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=(-DPHONON_BUILD_PHONON4QT5=OFF)
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(-DPHONON_BUILD_PHONON4QT5=ON)
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

pkg_postinst() {
	elog "For more verbose debug information, export the following variables:"
	elog "PHONON_DEBUG=1"
	elog ""
	elog "To make KDE detect the new backend without reboot, run:"
	elog "kbuildsycoca4 --noincremental"
}
