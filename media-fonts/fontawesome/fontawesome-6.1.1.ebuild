# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="The iconic font"
HOMEPAGE="https://fontawesome.com"
SRC_URI="https://github.com/FortAwesome/Font-Awesome/archive/refs/tags/6.1.1.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
S="${WORKDIR}/Font-Awesome-${PV}"

LICENSE="CC-BY-4.0 OFL-1.1"
SLOT="0/6"
IUSE="+otf ttf"

REQUIRED_USE="|| ( otf ttf )"
src_install() {
	if use otf; then
		FONT_S="${S}/otfs" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/webfonts" FONT_SUFFIX="ttf" font_src_install
	fi
}

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
