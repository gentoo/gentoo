# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3+ CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-arch/libarchive:=
	dev-db/sqlite:3
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5=
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libxcb:=
	>=x11-libs/xcb-util-keysyms-0.3.9
"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme
"
BDEPEND="kde-frameworks/extra-cmake-modules:*"

PATCHES=(
	"${FILESDIR}/${P}-disable-update-check.patch"
	"${FILESDIR}/${P}-cmake.patch"
)

src_prepare() {
# 	cat "${PATCHES[@]}" | grep '^+++' | cut -s -d / -f 2- | sort -u \
# 		| while read -r file
# 	do
# 		dos2unix "${file}" || die "Failed to convert line endings in ${file}"
# 	done

	cmake_src_prepare

	sed -i -e '/^ *set(CMAKE_COMPILE_WARNING_AS_ERROR ON)$/d' \
		CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DZEAL_RELEASE_BUILD=ON
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
