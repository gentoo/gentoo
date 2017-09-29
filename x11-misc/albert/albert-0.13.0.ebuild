# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLUGINS_HASH="bcca6aad60aa784cf61b8730e7865b399f163cc2"
inherit cmake-utils gnome2-utils

DESCRIPTION="Desktop agnostic launcher"
HOMEPAGE="https://albertlauncher.github.io/"
# plugins is a git submodule. the hash is taken from the submodule reference in the ${PV} tag.
SRC_URI="https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/albertlauncher/plugins/archive/${PLUGINS_HASH}.tar.gz -> ${P}-plugins.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	dev-cpp/muParser
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_prepare() {
	mv "${WORKDIR}"/plugins-${PLUGINS_HASH}/* "${S}"/plugins/ || die

	sed -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		-i plugins/*/CMakeLists.txt \
		-i src/lib/*/CMakeLists.txt || die

	# plugin needs virtualbox installed to build, untested
	sed -i -e "/add_subdirectory(virtualbox)/s/^/#/" plugins/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG_EXTENSIONS=$(usex debug)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
