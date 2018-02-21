# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit font

DESCRIPTION="OpenType font optimized for readability on small screens"
HOMEPAGE="https://01.org/clear-sans"
SRC_URI="https://01.org/sites/default/files/downloads/clear-sans/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}/TTF"
FONT_SUFFIX="ttf"
