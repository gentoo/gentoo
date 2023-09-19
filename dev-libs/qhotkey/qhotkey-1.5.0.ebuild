# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A global shortcut/hotkey library for desktop Qt applications"
HOMEPAGE="https://github.com/Skycoder42/QHotkey"

MY_PN="QHotkey"

SRC_URI="https://github.com/Skycoder42/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt6"
S="${WORKDIR}/${MY_PN}-${PV}"

DEPEND="
	!qt6?	(
			dev-qt/qtcore:5
			dev-qt/qtx11extras:5
		)
	qt6?	(
			dev-qt/qtbase:6
		)
	x11-libs/libX11
"

src_configure() {
	local mycmakeargs=(
		-DQT_DEFAULT_MAJOR_VERSION:STRING=$(usex qt6 "6" "5")
	)
	cmake_src_configure
}
