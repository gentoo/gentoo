# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg

DESCRIPTION="Simple (yet powerful) news feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard/"
SRC_URI="
	https://github.com/martinrotter/rssguard/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( LGPL-3 GPL-2+ ) AGPL-3+ BSD GPL-3+ MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="mysql qt6 +sqlite webengine"
REQUIRED_USE="|| ( mysql sqlite )"

BDEPEND="
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"
DEPEND="
	sys-libs/zlib:=
	!qt6? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5[gstreamer]
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtsql:5[mysql?,sqlite?]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		webengine? ( dev-qt/qtwebengine:5[widgets(+)] )
	)
	qt6? (
		dev-qt/qtbase:6[concurrent,dbus,gui,mysql?,network,sql,sqlite?,ssl,widgets]
		dev-qt/qtdeclarative:6
		dev-qt/qtmultimedia:6[gstreamer]
		dev-qt/qt5compat:6
		media-libs/libglvnd
		webengine? ( dev-qt/qtwebengine:6[widgets(+)] )
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=$(usex qt6)
		-DUSE_WEBENGINE=$(usex webengine)
		-DNO_UPDATE_CHECK=ON
		-DENABLE_COMPRESSED_SITEMAP=ON
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "ad blocking functionality" "net-libs/nodejs[npm]"
}
