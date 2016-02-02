# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils qt4-r2 git-r3

DESCRIPTION="A PSP emulator written in C++."
HOMEPAGE="http://www.ppsspp.org/"
EGIT_REPO_URI="git://github.com/hrydgard/${PN}.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5 +sdl"
REQUIRED_USE="
	?? ( qt4 qt5 sdl )
"

RDEPEND=""

DEPEND="
	sys-libs/zlib
	sdl? (
		dev-util/cmake
		media-libs/libsdl
		media-libs/libsdl2
	)
	qt4? (
		dev-qt/qtsvg:4
		dev-qt/qtgui:4
		dev-qt/qtcore:4
		dev-qt/qtopengl:4
		dev-qt/qtmultimedia:4
		dev-qt/qt-mobility[multimedia]
	)
	qt5? (
		dev-qt/qtsvg:5
		dev-qt/qtgui:5
		dev-qt/qtcore:5
		dev-qt/qtopengl:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		dev-qt/qt-mobility[multimedia]
	)
"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_unpack
	elif use qt5 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_unpack
	fi
}

src_prepare() {
	epatch "$FILESDIR"/ppsspp-cmake.patch
	epatch "$FILESDIR"/ppsspp-ffmpeg-x86_64.patch
	epatch "$FILESDIR"/ppsspp-ffmpeg-x86.patch
	epatch "$FILESDIR"/ppsspp-qt.patch
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_prepare
	elif use qt5 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_prepare
	else
		cmake-utils_src_prepare
	fi
}

src_configure() {
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_configure
		eqmake4 "${WORKDIR}"/"${P}"/Qt/PPSSPPQt.pro
	elif use qt5 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_configure
		eqmake5 "${WORKDIR}"/"${P}"/Qt/PPSSPPQt.pro
	else
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_compile
	elif use qt5 ; then
		cd "${WORKDIR}"/"${P}"/Qt || die
		qt4-r2_src_compile
	else
		cmake-utils_src_compile
	fi
}

src_install() {
	if use qt4 ; then
		into /usr/games/bin
		newexe "${WORKDIR}"/"${P}"/Qt/ppsspp ppsspp
	elif use qt5 ; then
		exeinto /usr/games/bin
		newexe "${WORKDIR}"/"${P}"/Qt/ppsspp ppsspp
	else
		exeinto /usr/games
		dobin "${FILESDIR}"/ppsspp
		exeinto /usr/share/games/"${PN}"
		doexe "${WORKDIR}"/"${P}"_build/PPSSPPSDL
		insinto /usr/share/games/"${PN}"
		doins -r "${WORKDIR}"/"${P}"_build/assets
		doins -r "${WORKDIR}"/"${P}"/lang
	fi
	insinto /usr/share/icons/
	newins "${WORKDIR}"/"${P}"/source_assets/image/icon_regular_72.png ppsspp-icon.png
	domenu "${FILESDIR}"/ppsspp.desktop
}

pkg_postinst() {
	elog "Remember, in order to play games, you have to "
	elog "be in the 'games' group. "
	elog "Just run 'gpasswd -a <USER> games', then have <USER> re-login. "
}
