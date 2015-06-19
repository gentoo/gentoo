# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/sonnet/sonnet-5.11.0.ebuild,v 1.1 2015/06/15 18:35:12 kensington Exp $

EAPI=5

inherit kde5

DESCRIPTION="Framework for providing spell-checking capabilities through abstraction of popular backends"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
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
