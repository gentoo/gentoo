# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Vollkorn, the free and healthy typeface for bread and butter use"
HOMEPAGE="http://vollkorn-typeface.com/"
SRC_URI="http://vollkorn-typeface.com/download/${PN}-${PV/./-}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~loong ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+otf +ttf"
REQUIRED_USE="|| ( otf ttf )"
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
DOCS="Fontlog.txt"

src_install() {
	if use otf; then
		FONT_S="${S}/PS-OTF" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/TTF" FONT_SUFFIX="ttf" font_src_install
	fi
}
