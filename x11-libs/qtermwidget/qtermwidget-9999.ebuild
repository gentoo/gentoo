# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/lxde/qtermwidget"
EGIT_REPO_URI="https://github.com/lxde/qtermwidget.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
