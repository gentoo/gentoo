# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for providing spell-checking through abstraction of popular backends"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="aspell +hunspell nls"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell:= )
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package aspell ASPELL)
		$(cmake-utils_use_find_package hunspell HUNSPELL)
	)

	kde5_src_configure
}
