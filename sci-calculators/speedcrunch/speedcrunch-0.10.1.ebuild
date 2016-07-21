# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="A fast and usable calculator for power users"
HOMEPAGE="https://code.google.com/p/speedcrunch/"
SRC_URI="https://speedcrunch.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

LANGS="ca cs de en es es_AR eu fi fr he id it nb nl no pl
	pt pt_BR ro ru sv tr zh_CN"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

S="${WORKDIR}/${P}/src"

src_prepare( ) {
	epatch "${FILESDIR}"/${P}-iconname.patch
	# regenerate translations
	lrelease speedcrunch.pro || die
	local lang
	for lang in ${LANGS}; do
		if ! use linguas_${lang}; then
			sed -i -e "s:i18n/${lang}\.qm::" Translations.cmake || die
			sed -i -e "s:books/${lang}::" CMakeLists.txt || die
		fi
	done
}

src_install() {
	cmake-utils_src_install
	cd ..
	dodoc ChangeLog ChangeLog.floatnum HACKING.txt LISEZMOI README TRANSLATORS
	use doc && dodoc doc/*.pdf
}
