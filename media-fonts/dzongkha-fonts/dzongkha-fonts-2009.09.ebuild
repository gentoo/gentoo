# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/dzongkha-fonts/dzongkha-fonts-2009.09.ebuild,v 1.2 2015/04/28 09:23:49 yngwin Exp $

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
