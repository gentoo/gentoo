# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX="ttf"
inherit font readme.gentoo-r1

DESCRIPTION="A font for better emoji and unicode support"
HOMEPAGE="https://www.joypixels.com/"
SRC_URI="https://cdn.joypixels.com/distributions/gentoo-linux/font/${PV}/joypixels-android.ttf -> ${P}.ttf"
S="${WORKDIR}"

#https://cdn.joypixels.com/distributions/gentoo-linux/appendix/joypixels-license-appendix.txt
#https://cdn.joypixels.com/distributions/gentoo-linux/license/free-license.txt
LICENSE="JoyPixels"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"
RESTRICT="bindist mirror"

FONT_CONF=( "${FILESDIR}"/99-joypixels.conf )

DOC_CONTENTS="Free for personal/education use only, premium/enterprise license
	required for any other use. See: https://www.joypixels.com/licenses"

src_prepare() {
	default
	cp "${DISTDIR}"/${P}.ttf "${S}"/${P}.ttf || die
}

src_install() {
	font_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	font_pkg_postinst
}
