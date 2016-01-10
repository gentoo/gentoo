# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils qt4-r2 git-r3

DESCRIPTION="A PSP emulator for Android, Windows, Mac, Linux and Blackberry 10, written in C++."
HOMEPAGE="http://www.ppsspp.org/"
EGIT_REPO_URI="git://github.com/hrydgard/ppsspp.git"
SRC_URI="http://www.ppsspp.org/img/ppsspp-icon.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-qt4 sdl"
REQUIRED_USE="
	?? ( qt4 sdl )
"

RDEPEND=""
DEPEND="sys-libs/zlib
	sdl? ( media-libs/libsdl )
	sdl? ( media-libs/libsdl2 )
	sdl? ( dev-util/cmake )
	qt4? ( dev-qt/qtcore:4 )
	qt4? ( dev-qt/qtgui:4 )
	qt4? ( dev-qt/qtmultimedia:4 )
	qt4? ( dev-qt/qtopengl:4 )
	qt4? ( dev-qt/qtsvg:4 )
	qt4? ( dev-qt/qt-mobility[multimedia] )"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt
		qt4-r2_src_unpack
	fi
	cp /usr/portage/distfiles/ppsspp-icon.png  "${WORKDIR}"/"${P}"/
}

src_prepare() {
	epatch "$FILESDIR"/ppsspp-cmake.patch
	epatch "$FILESDIR"/ppsspp-ffmpeg-x86_64.patch
	epatch "$FILESDIR"/ppsspp-ffmpeg-x86.patch
	epatch "$FILESDIR"/ppsspp-qt.patch
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt
		qt4-r2_src_prepare
	else
		cmake-utils_src_prepare
	fi
}

src_configure() {
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt
		qt4-r2_src_configure
		eqmake4 "${WORKDIR}"/"${P}"/Qt/PPSSPPQt.pro
	else
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use qt4 ; then
		cd "${WORKDIR}"/"${P}"/Qt
		qt4-r2_src_compile
	else
		cmake-utils_src_compile
	fi
}

src_install() {
	if use qt4 ; then
		into /usr/games
		dobin "${FILESDIR}"/ppssppqt
		domenu "${FILESDIR}"/ppsspp-qt.desktop
		exeinto /usr/share/games/"${PN}"
		newexe "${WORKDIR}"/"${P}"/Qt/ppsspp PPSSPPQt
	else
		into /usr/games
		dobin "${FILESDIR}"/ppssppsdl
		domenu "${FILESDIR}"/ppsspp-sdl.desktop
		exeinto /usr/share/games/"${PN}"
		doexe "${WORKDIR}"/"${P}"_build/PPSSPPSDL
		insinto /usr/share/games/"${PN}"
		doins -r "${WORKDIR}"/"${P}"_build/assets
		doins -r "${WORKDIR}"/"${P}"/lang
	fi
	insinto /usr/share/icons/
        newins "${WORKDIR}"/"${P}"/ppsspp-icon.png ppsspp-icon.png
}
