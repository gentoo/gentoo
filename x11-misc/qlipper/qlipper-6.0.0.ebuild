# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Lightweight and cross-platform clipboard history applet"
HOMEPAGE="https://github.com/pvanek/qlipper"
SRC_URI="https://github.com/pvanek/qlipper/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

# qmenuview/* and qxt/* are licensed under GPL-3+ and BSD respectively.
LICENSE="GPL-2+ BSD GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: still accurate? bundles x11-libs/libqxt but no qt6 system version is available yet
RDEPEND="
	dev-qt/qtbase:6=[gui,widgets]
	dev-qt/qtsvg:6
	kde-frameworks/kguiaddons:6
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=( "${FILESDIR}/${P}-cmake4.patch" )
