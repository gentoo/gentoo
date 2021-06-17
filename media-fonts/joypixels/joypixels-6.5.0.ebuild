# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX="ttf"
inherit font

DESCRIPTION="A font for better emoji and unicode support"
HOMEPAGE="https://www.joypixels.com/"
SRC_URI="https://cdn.joypixels.com/distributions/gentoo-linux/font/${PV}/joypixels-android.ttf -> ${P}.ttf"
S="${WORKDIR}"

#https://cdn.joypixels.com/distributions/gentoo-linux/appendix/joypixels-license-appendix.txt
#https://cdn.joypixels.com/distributions/gentoo-linux/license/free-license.txt
LICENSE="JoyPixels"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"

FONT_CONF=( "${FILESDIR}"/99-joypixels.conf )

src_prepare() {
	default
	cp "${DISTDIR}"/${P}.ttf "${S}"/${P}.ttf || die
}
