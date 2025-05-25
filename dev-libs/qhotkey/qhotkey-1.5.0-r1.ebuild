# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="QHotkey"
inherit cmake

DESCRIPTION="A global shortcut/hotkey library for desktop Qt applications"
HOMEPAGE="https://github.com/Skycoder42/QHotkey"
SRC_URI="https://github.com/Skycoder42/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase:6[X,gui]
	x11-libs/libX11
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-wayland-crash.patch
	"${FILESDIR}"/${P}-cmake4.patch
)

src_configure() {
	local mycmakeargs=(
		-DQT_DEFAULT_MAJOR_VERSION:STRING=6
	)
	cmake_src_configure
}
