# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION=2.8

inherit cmake-utils

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"
SRC_URI="http://qmmp.ylsoftware.com/files/plugins/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/taglib
	media-sound/mpg123
	media-sound/qmmp
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	dev-lang/yasm"
