# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Monocle, the modular document viewer for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug +djvu doc +fb2 +mobi +pdf +postscript"

REQUIRED_USE="postscript? ( pdf )"

CDEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtprintsupport:5
	dev-qt/qtxml:5
	pdf? ( app-text/poppler[qt5] )
	djvu? ( app-text/djvu )"

RDEPEND="${CDEPEND}
	postscript? ( app-text/ghostscript-gpl )"

DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen[dot] )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_MONOCLE_SEEN=$(usex djvu)
		-DWITH_DOCS=$(usex doc)
		-DENABLE_MONOCLE_FXB=$(usex fb2)
		-DENABLE_MONOCLE_DIK=$(usex mobi)
		-DENABLE_MONOCLE_PDF=$(usex pdf)
		-DENABLE_MONOCLE_POSTRUS=$(usex postscript)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${CMAKE_BUILD_DIR}"/out/html/*
}
