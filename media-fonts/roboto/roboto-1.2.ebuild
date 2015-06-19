# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/roboto/roboto-1.2.ebuild,v 1.4 2015/03/03 08:17:06 dlan Exp $

inherit font

DESCRIPTION="Standard font for Android 4.0 (Ice Cream Sandwich) and later"
HOMEPAGE="http://developer.android.com/design/style/typography.html"
SRC_URI="http://developer.android.com/downloads/design/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/90-roboto-regular.conf" )

src_install() {
	FONT_S="${WORKDIR}/Roboto_v${PV}"/Roboto font_src_install
	FONT_S="${WORKDIR}/Roboto_v${PV}"/RobotoCondensed font_src_install
}
