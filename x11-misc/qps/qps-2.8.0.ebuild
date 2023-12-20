# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Qt GUI Process Manager"
HOMEPAGE="https://lxqt-project.org/"
SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2 GPL-2+ LGPL-2.1+ QPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv ~x86"

BDEPEND="
	>=dev-qt/linguist-tools-5.15:5
	>=dev-util/lxqt-build-tools-0.13.0
"
DEPEND="
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtgui-5.15:5
	>=dev-qt/qtwidgets-5.15:5
	>=lxqt-base/liblxqt-1.4:=
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
