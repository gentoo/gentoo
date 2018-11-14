# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit font

DESCRIPTION="Fonts for the Khmer language of Cambodia"
HOMEPAGE="http://www.khmeros.info/drupal/?q=en/download/fonts"
SRC_URI="mirror://sourceforge/khmer/All_KhmerOS_${PV}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/All_KhmerOS_${PV}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	unpack ${A}
	cd "${S}"
	[[ -f "KhmerOS .ttf" ]] && mv "KhmerOS .ttf" "KhmerOS.ttf" # 338057
}

pkg_postinst() {
	font_pkg_postinst
	echo
	elog "To prefer using Khmer OS fonts, run:"
	elog
	elog "	eselect fontconfig enable 65-khmer.conf"
	echo
}
