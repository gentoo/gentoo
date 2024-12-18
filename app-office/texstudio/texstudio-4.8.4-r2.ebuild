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
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

IUSE="video"

DEPEND="
	app-text/hunspell:=
	app-text/poppler:=[qt6]
	>=dev-libs/quazip-1.0:0=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[widgets]
	sys-libs/zlib
	x11-libs/libX11
	video? ( dev-qt/qtmultimedia:6 )
"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl
	app-text/psutils
	media-libs/netpbm
	virtual/latex-base
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_prepare() {
	local dir
	for dir in src/quazip src/hunspell utilities/poppler-data; do
		rm -r "${dir}" || die "Failed to delete ${dir}"
	done

	# https://bugs.gentoo.org/940747
	sed -i 's/Qt5 //' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6
	)
	use video && mycmakeargs+=( -DTEXSTUDIO_ENABLE_MEDIAPLAYER=ON )
	cmake_src_configure
}

src_install() {
	cmake_src_install

	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		newicon -s ${i} utilities/${PN}${i}.png ${PN}.png
	done
}
