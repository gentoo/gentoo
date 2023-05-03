# Copyright 1999-2023 Gentoo Authors
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
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+adwaita test video"

DEPEND="
	app-text/hunspell:=
	app-text/poppler:=[qt5]
	>=dev-libs/quazip-1.0:0=[qt5(+)]
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	adwaita? ( dev-qt/qtdbus:5 )
	test? ( dev-qt/qttest:5 )
	video? ( dev-qt/qtmultimedia:5[widgets] )
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

src_install() {
	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		newicon -s ${i} utilities/${PN}${i}.png ${PN}.png
	done

	cmake_src_install

	# We don't install licences per package
	rm "${ED}"/usr/share/texstudio/COPYING || die
}
