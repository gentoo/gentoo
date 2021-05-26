# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED=test

inherit cmake virtualx xdg-utils

DESCRIPTION="Qt Bible-study application using the SWORD library"
HOMEPAGE="http://bibletime.info/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

# As of 3.0.0 most tests fail unless Bibletime has previously been installed,
# and one fails for unknown reasons even then. See:
#  https://github.com/bibletime/bibletime/issues/320
#  https://github.com/bibletime/bibletime/issues/321
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
#BDEPEND="test? (
#	app-dicts/sword-Josephus
#	app-dicts/sword-KJV
#	app-dicts/sword-KJVA
#	app-dicts/sword-Scofield
#	app-dicts/sword-StrongsGreek
#)"

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

src_test() {
	virtx cmake_src_test || die "Test run has failed"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
