# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Bhutanese style dbu-can font for Tibetan/Dzongkha text named after Mt Jomolhari"
HOMEPAGE="http://www.library.gov.bt/IT/fonts.html"
SRC_URI="mirror://nongnu/free-tibetan/${PN}/${PN}-alpha${PV:(-2)}.tar.gz"
S="${WORKDIR}"

LICENSE="OFL"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
IUSE=""

FONT_SUFFIX="ttf"
