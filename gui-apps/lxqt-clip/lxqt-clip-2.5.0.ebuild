# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Clipboard History Applet for X11 and Wayland"
HOMEPAGE="
	https://lxqt-project.org/
	https://github.com/lxqt/lxqt-clip/
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="BSD GPL-2+"
SLOT="0"

BDEPEND="dev-qt/qttools:6[linguist]"
RDEPEND="
	dev-qt/qtbase:6=[gui,widgets]
	kde-frameworks/kguiaddons:6
	=lxqt-base/liblxqt-${MY_PV}*:=
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
