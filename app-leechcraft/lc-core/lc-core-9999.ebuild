# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/0xd34df00d/leechcraft.git"

inherit leechcraft

DESCRIPTION="Core of LeechCraft, the modular network client"

SLOT="0"
KEYWORDS=""
IUSE="debug doc postgres +qwt"

DEPEND="
	dev-libs/boost:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	qwt? ( x11-libs/qwt:6 )
"
RDEPEND="${DEPEND}
	dev-qt/qtsql:5[postgres?,sqlite]
	dev-qt/qtsvg:5
	|| (
		kde-frameworks/oxygen-icons
		x11-themes/kfaenza
	)
"
BDEPEND="
	dev-qt/linguist-tools:5
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DWITH_PLUGINS=False
		-DSKIP_MAN_COMPRESS=True
		-DWITH_DOCS=$(usex doc)
		-DWITH_QWT=$(usex qwt)
	)
	if [[ ${PV} != 9999 ]]; then
		mycmakeargs+=( -DLEECHCRAFT_VERSION=${PV} )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${CMAKE_BUILD_DIR}/${PN#lc-}"/out/html/*
}
