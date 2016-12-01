# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils git-r3

DESCRIPTION="A PSP emulator written in C++."
HOMEPAGE="http://www.ppsspp.org/"
EGIT_REPO_URI="git://github.com/hrydgard/${PN}.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="qt5 +system-ffmpeg"

RDEPEND="
	sys-libs/zlib
	dev-libs/libzip
	virtual/opengl
	media-libs/libsdl
	media-libs/libsdl2
	app-arch/snappy
	system-ffmpeg? ( virtual/ffmpeg )
	qt5? (
		dev-qt/qtsvg:5
		dev-qt/qtgui:5
		dev-qt/qtcore:5
		dev-qt/qtopengl:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		dev-qt/qt-mobility[multimedia]
	)"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_unpack() {
	if use system-ffmpeg ; then
		EGIT_SUBMODULES=(lang ext/armips ext/ppsspp-glslang ext/tinyformat)
	else
		EGIT_SUBMODULES=(lang ext/armips ext/ppsspp-glslang ext/tinyformat ffmpeg)
	fi
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	sed -i -e "s#-O3#-O2#g;" "${S}"/CMakeLists.txt || die
	if use !system-ffmpeg ; then
	sed -i -e "s#-O3#-O2#g;" "${S}"/ffmpeg/linux_*.sh || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt5 USING_QT_UI)
		$(cmake-utils_use system-ffmpeg USE_SYSTEM_FFMPEG)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
if use qt5 ; then
		exeinto usr/share/games/"${PN}"
		newexe "${WORKDIR}"/"${P}"_build/PPSSPPQt ppsspp
	else
		exeinto /usr/share/games/"${PN}"
		newexe "${WORKDIR}"/"${P}"_build/PPSSPPSDL ppsspp

	fi
	exeinto /usr/games/bin
	doexe "${FILESDIR}"/ppsspp
	insinto /usr/share/games/"${PN}"
	doins -r "${WORKDIR}"/"${P}"_build/assets
	newicon "${WORKDIR}"/"${P}"/source_assets/image/icon_regular_72.png ppsspp-icon.png
	domenu "${FILESDIR}"/ppsspp.desktop
}

pkg_postinst() {
	elog "Remember, in order to play games, you have to "
	elog "be in the 'games' group. "
	elog "Just run 'gpasswd -a <USER> games', then have <USER> re-login. "
}
