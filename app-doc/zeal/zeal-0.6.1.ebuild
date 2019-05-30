# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="vanilla"

DEPEND="
	app-arch/libarchive
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/extra-cmake-modules:5
	>=x11-libs/xcb-util-keysyms-0.3.9
"

RDEPEND="
	${DEPEND}
	x11-themes/hicolor-icon-theme
"

src_prepare() {
	default
	eapply "${FILESDIR}/0001-libs-enforce-static-linking-of-internal-libs.patch"
	if ! use vanilla; then
		eapply "${FILESDIR}/0002-settings-disable-checking-for-updates-by-default.patch"
	fi
	cmake-utils_src_prepare
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
