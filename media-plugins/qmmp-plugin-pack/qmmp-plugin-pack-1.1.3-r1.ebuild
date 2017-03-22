# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"
SRC_URI="http://qmmp.ylsoftware.com/files/plugins/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsamplerate
	>=media-libs/taglib-1.10
	media-sound/mpg123
	=media-sound/qmmp-$(get_version_component_range 1-2)*
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-qt/linguist-tools:5
"
