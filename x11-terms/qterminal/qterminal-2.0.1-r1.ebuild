# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Qt-based multitab terminal emulator"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="GPL-2 GPL-2+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=dev-util/lxqt-build-tools-2.0.0"
DEPEND="
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets,X]
	kde-plasma/layer-shell-qt:6
	media-libs/libcanberra
	x11-libs/libX11
	~x11-libs/qtermwidget-${PV}:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
