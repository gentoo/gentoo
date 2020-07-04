# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Nunavut's official Inuktitut font"
HOMEPAGE="http://www.ch.gov.nu.ca/en/ComputerTools.aspx"
SRC_URI="http://ch.gov.nu.ca/fonts/pigiarniq.zip -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"
