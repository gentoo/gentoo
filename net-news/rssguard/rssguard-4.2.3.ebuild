# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN="5.10.0"
inherit cmake optfeature xdg

DESCRIPTION="Simple (yet powerful) feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard"
SRC_URI="https://github.com/martinrotter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-3 GPL-2+ ) AGPL-3+ BSD GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="webengine"

BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"
DEPEND="
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer]
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:5[widgets(+)] )
"
RDEPEND="${DEPEND}"

DOCS=( README.md resources/docs/Documentation.md )

src_configure() {
	local mycmakeargs=(
		-DUSE_WEBENGINE=$(usex webengine)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	if use webengine; then
		optfeature "ad blocking functionality" net-libs/nodejs[npm]
		elog "Adblocker module requires additional npm modules to be installed:"
		elog "npm i -g @cliqz/adblocker tldts-experimental"
	fi
}
