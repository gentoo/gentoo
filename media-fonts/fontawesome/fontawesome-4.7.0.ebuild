# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

REPO_PN="Font-Awesome"

DESCRIPTION="The iconic font"
HOMEPAGE="http://fontawesome.io"
SRC_URI="https://github.com/FortAwesome/${REPO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-3.0 OFL-1.1"
SLOT="0/4"
KEYWORDS="amd64 arm arm64 x86"
IUSE="+otf +ttf"

REQUIRED_USE="|| ( otf ttf )"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${REPO_PN}-${PV}"

FONT_S="${S}/fonts"
FONT_SUFFIX=""

src_configure() {
	use otf && FONT_SUFFIX+="otf "
	use ttf && FONT_SUFFIX+="ttf "
}
