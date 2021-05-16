# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Pothana 2000 and Vemana fonts for the Telugu script"
HOMEPAGE="http://www.kavya-nandanam.com/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${WORKDIR}"
FONT_SUFFIX="ttf"

FONT_CONF=( "${FILESDIR}/65-pothana2k.conf" )

src_install() {
	font_src_install
	use doc && dodoc MANUAL.PDF
}
