# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Qt-based multitab terminal emulator"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=dev-util/lxqt-build-tools-0.13.0"
DEPEND="
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtdbus-5.15:5
	>=dev-qt/qtgui-5.15:5
	>=dev-qt/qtwidgets-5.15:5
	>=dev-qt/qtx11extras-5.15:5
	x11-libs/libX11
	~x11-libs/qtermwidget-${PV}:=
	test? ( dev-qt/qttest:5 )
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
