# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/0xd34df00d/leechcraft.git"

inherit leechcraft

DESCRIPTION="Core of LeechCraft, the modular network client"

SLOT="0"
KEYWORDS=""
IUSE="debug doc +sqlite postgres +qwt"

COMMON_DEPEND=">=dev-libs/boost-1.62
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5
	dev-qt/qtdeclarative:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5[postgres?,sqlite?]
	dev-qt/qtdbus:5
	dev-qt/qtwebkit:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtconcurrent:5
	dev-qt/linguist-tools:5
	qwt? ( x11-libs/qwt:6 )"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:5
	|| (
		kde-frameworks/oxygen-icons
		x11-themes/kfaenza
	 )"

REQUIRED_USE="|| ( postgres sqlite )"

src_configure() {
	local mycmakeargs=(
		-DWITH_PLUGINS=False
		-DWITH_DOCS=$(usex doc)
		-DWITH_QWT=$(usex qwt)
	)
	if [[ ${PV} != 9999 ]]; then
		mycmakeargs+=( -DLEECHCRAFT_VERSION=${PV} )
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${CMAKE_BUILD_DIR}/${PN#lc-}"/out/html/*
}
