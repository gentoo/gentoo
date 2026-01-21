# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop optfeature xdg

DESCRIPTION="Free cross-platform LaTeX editor (fork from texmakerX)"
HOMEPAGE="https://www.texstudio.org https://github.com/texstudio-org/texstudio"
SRC_URI="https://github.com/texstudio-org/texstudio/archive/${PV}.tar.gz -> ${P}.tar.gz"

# MIT: To Title Case
# LGPL-2: Crystal Project
# CC-BY-SA-3.0: Oxygen icon theme
# CC0-1.0: Colibre icon theme
LICENSE="GPL-3 MIT LGPL-2 CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="video"

DEPEND="
	app-text/hunspell:=
	app-text/poppler:=[qt6]
	>=dev-libs/quazip-1.3-r2:0=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[widgets]
	virtual/zlib:=
	x11-libs/libX11
	video? ( dev-qt/qtmultimedia:6 )
"
RDEPEND="
	${DEPEND}
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
		# already exists in ::gentoo, useful only for win
		-DTEXSTUDIO_BUILD_ADWAITA=NO
		-DTEXSTUDIO_ENABLE_MEDIAPLAYER=$(usex video)
		# it requires debug and make changes in the UI
		# see #940928
		-DTEXSTUDIO_ENABLE_TESTS=NO
	)
	cmake_src_configure
}

src_install() {
	# manually set docdir to use a subdir for html
	# and avoid the path /usr/share/doc/texstudio
	local DOCS+=( utilities/{AUTHORS,COPYING,manual/source/CHANGELOG.md} )
	local HTML_DOCS+=( utilities/*.{html,css} utilities/manual/build/html/. )
	cmake_src_install

	# remove the wrong path
	rm -r "${ED}"/usr/share/doc/texstudio || die

	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		newicon -s ${i} utilities/${PN}${i}.png ${PN}.png
	done
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "conversion tools" app-text/ghostscript-gpl
	optfeature "PostScript tools" app-text/psutils
	optfeature "graphic tools" media-libs/netpbm
	optfeature "automation" dev-tex/latexmk
	optfeature "XeLaTex engine" dev-texlive/texlive-xetex
	optfeature "the vector graphics language (.asy)" media-gfx/asymptote
}
