# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

REPO_PN="Font-Awesome"

MY_P="${PN}-free-${PV}"

DESCRIPTION="The iconic font"
HOMEPAGE="https://fontawesome.com"
SRC_URI="https://github.com/FortAwesome/${REPO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://use.fontawesome.com/releases/v${PV}/${MY_P}.zip"

LICENSE="CC-BY-3.0 OFL-1.1"
SLOT="0/5"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+otf +ttf"

REQUIRED_USE="|| ( otf ttf )"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	if use otf; then
		FONT_S="${S}/use-on-desktop" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/web-fonts-with-css/webfonts" FONT_SUFFIX="ttf" font_src_install
	fi
}
