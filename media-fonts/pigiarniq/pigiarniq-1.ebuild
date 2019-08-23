# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit font

DESCRIPTION="Nunavut's official Inuktitut font"
HOMEPAGE="http://www.gov.nu.ca/english/font/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.zip"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
DEPEND="app-arch/unzip"
RDEPEND=""
S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"
