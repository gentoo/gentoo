# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Framework for providing spell-checking through abstraction of popular backends"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS=" ~amd64 ~x86"
IUSE="+aspell hunspell nls"

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell )
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package aspell)
		$(cmake-utils_use_find_package hunspell)
	)

	kde5_src_configure
}
