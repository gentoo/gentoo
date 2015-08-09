# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Bhutanese/Tibetan fonts for dzongkha script, provided by the Bhutanese government"
HOMEPAGE="http://www.dit.gov.bt/downloads"
SRC_URI="http://www.dit.gov.bt/sites/default/files/dzongkhafonts.zip -> ${P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	default
	unpack ./*.zip
}
