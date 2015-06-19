# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ubuntu-font-family/ubuntu-font-family-0.80.ebuild,v 1.4 2013/01/21 20:03:56 steev Exp $

EAPI=4

inherit font

DESCRIPTION="A set of matching libre/open fonts funded by Canonical"
HOMEPAGE="http://font.ubuntu.com/"
SRC_URI="http://font.ubuntu.com/download/${P}.zip"

LICENSE="UbuntuFontLicense-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_SUFFIX="ttf"

DOCS="CONTRIBUTING.txt FONTLOG.txt README.txt"

src_prepare() {
	rm "${S}"/Ubuntu-M*.ttf
}
