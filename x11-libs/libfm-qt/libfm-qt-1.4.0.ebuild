# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake xdg-utils

DESCRIPTION="Qt Library for Building File Managers"
HOMEPAGE="https://lxqt-project.org/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="BSD GPL-2+ LGPL-2.1+"
SLOT="0/7"

BDEPEND="
	>=dev-qt/linguist-tools-5.15:5
	>=dev-util/lxqt-build-tools-0.13.0
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtgui-5.15:5=
	>=dev-qt/qtwidgets-5.15:5
	>=dev-qt/qtx11extras-5.15:5
	>=lxde-base/menu-cache-1.1.0:=
	=lxqt-base/lxqt-menu-data-${MY_PV}*
	media-libs/libexif
	x11-libs/libxcb:=
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}
