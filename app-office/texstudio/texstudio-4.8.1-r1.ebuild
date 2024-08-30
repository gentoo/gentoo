# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

MY_PV="${PV/_/}"
DESCRIPTION="Free cross-platform LaTeX editor (fork from texmakerX)"
HOMEPAGE="https://www.texstudio.org https://github.com/texstudio-org/texstudio"
SRC_URI="https://github.com/texstudio-org/texstudio/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+adwaita test video"
RESTRICT="!test? ( test )"

DEPEND="
	app-text/hunspell:=
	app-text/poppler:=[qt6]
	dev-libs/quazip:=[qt6(+)]
	dev-qt/qt5compat[icu]
	dev-qt/qtdeclarative:6
	dev-qt/qtbase[icu]
	dev-qt/qtsvg:6
	dev-qt/qttools
	sys-libs/zlib
	x11-libs/libX11
	adwaita? ( dev-qt/qtbase[dbus] )
	test? ( dev-qt/qtbase[test] )
	video? ( dev-qt/qtmultimedia:6 )
"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl
	app-text/psutils
	media-libs/netpbm
	virtual/latex-base
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# TODO: find adwaita-qt qtsingleapplication -delete || die

	## force use of Qt6
	sed -e s,Qt5,, -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=( )
	! use adwaita && mycmakeargs+=( -DTEXSTUDIO_BUILD_ADWAITA=OFF )
	if use test ; then
		CMAKE_BUILD_TYPE=Debug
		mycmakeargs+=( -DTEXSTUDIO_ENABLE_TESTS=ON )
	fi
	use video && mycmakeargs+=( -DTEXSTUDIO_ENABLE_MEDIAPLAYER=ON )
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	QT_QPA_PLATFORM=offscreen ./texstudio --auto-tests
}

src_install() {
	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		newicon -s ${i} utilities/${PN}${i}.png ${PN}.png
	done

	cmake_src_install

	# We don't install licences per package
	rm "${ED}"/usr/share/texstudio/COPYING || die
}
