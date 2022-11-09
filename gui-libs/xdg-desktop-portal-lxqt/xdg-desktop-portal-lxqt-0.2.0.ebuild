# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake

DESCRIPTION="Backend implementation for xdg-desktop-portal using Qt/KF5/libfm-qt"
HOMEPAGE="https://lxqt-project.org/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~loong ~riscv x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND=">=dev-util/lxqt-build-tools-0.11.0"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kwindowsystem:5
	x11-libs/libfm-qt:=
"
RDEPEND="${DEPEND}
	sys-apps/xdg-desktop-portal
"
