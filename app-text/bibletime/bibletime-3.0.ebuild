# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Qt Bible-study application using the SWORD library"
HOMEPAGE="http://bibletime.info/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

# Known to fail and will all be gone come next release (see upstream commit
# d05797db79074c526987329dff78d89eef8c501c)
RESTRICT="test"

RDEPEND=">=app-text/sword-1.8.1
	dev-cpp/clucene
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/icu:=
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
	net-misc/curl
	sys-libs/zlib"

DOCS=( ChangeLog README.md )

src_prepare() {
	cmake_src_prepare

	sed -e "s:Dictionary;Qt:Dictionary;Office;TextTools;Utility;Qt:" \
		-i cmake/platforms/linux/bibletime.desktop.cmake || die "fixing .desktop file failed"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_HANDBOOK_HTML=no
		-DBUILD_HANDBOOK_PDF=no
		-DBUILD_HOWTO_HTML=no
		-DBUILD_HOWTO_PDF=no
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
