# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake xdg-utils

DESCRIPTION="Qt Image Viewer"
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

BDEPEND="
	>=dev-qt/linguist-tools-5.15:5
	>=dev-util/lxqt-build-tools-0.13.0
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtdbus-5.15:5
	>=dev-qt/qtgui-5.15:5
	>=dev-qt/qtnetwork-5.15:5
	>=dev-qt/qtprintsupport-5.15:5
	>=dev-qt/qtsvg-5.15:5
	>=dev-qt/qtwidgets-5.15:5
	>=dev-qt/qtx11extras-5.15:5
	media-libs/libexif
	=x11-libs/libfm-qt-${MY_PV}*:=
	x11-libs/libX11
	x11-libs/libXfixes
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
