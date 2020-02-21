# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Fonts for the Khmer language of Cambodia"
HOMEPAGE="http://www.khmeros.info/drupal/?q=en/download/fonts"
SRC_URI="mirror://sourceforge/khmer/All_KhmerOS_${PV}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/All_KhmerOS_${PV}"

FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	default

	# bug 338057
	mv KhmerOS{\ ,}.ttf || die
}

pkg_postinst() {
	font_pkg_postinst

	elog "To prefer using Khmer OS fonts, run:"
	elog
	elog "	eselect fontconfig enable 65-khmer.conf"
}
