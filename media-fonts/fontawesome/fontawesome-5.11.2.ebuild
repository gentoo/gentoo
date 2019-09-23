# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="Font-Awesome"
inherit font

DESCRIPTION="The iconic font"
HOMEPAGE="https://fontawesome.com"
SRC_URI="https://github.com/FortAwesome/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-4.0 OFL-1.1"
SLOT="0/5"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+otf +ttf"

REQUIRED_USE="|| ( otf ttf )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	if use otf; then
		FONT_S="${S}/otfs" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/webfonts" FONT_SUFFIX="ttf" font_src_install
	fi
}
