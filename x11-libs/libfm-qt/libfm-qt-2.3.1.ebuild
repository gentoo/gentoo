# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake xdg

DESCRIPTION="Qt Library for Building File Managers"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="BSD GPL-2+ LGPL-2.1+"
SLOT="0/17"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.3.0
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-6.6:6=[gui,widgets,X]
	>=lxde-base/menu-cache-1.1.0:=
	=lxqt-base/lxqt-menu-data-${MY_PV}*
	media-libs/libexif
	x11-libs/libxcb:=
"
RDEPEND="${DEPEND}"
