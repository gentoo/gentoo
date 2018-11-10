# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/lxde/qtermwidget"
EGIT_REPO_URI="https://github.com/lxde/qtermwidget.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${DEPEND}
	dev-util/lxqt-build-tools
	dev-qt/linguist-tools:5
"

PATCHES=( "${FILESDIR}/${P}-nofetch.patch" )
