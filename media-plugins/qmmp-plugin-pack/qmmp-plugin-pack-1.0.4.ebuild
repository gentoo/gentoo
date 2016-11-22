# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION=2.8

inherit cmake-utils

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"
SRC_URI="http://qmmp.ylsoftware.com/files/plugins/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/taglib-1.10
	media-sound/mpg123
	>=media-sound/qmmp-1.0.0
	dev-qt/qtgui:5
	dev-qt/qtx11extras:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-qt/linguist-tools:5"

#PATCHES=( )
