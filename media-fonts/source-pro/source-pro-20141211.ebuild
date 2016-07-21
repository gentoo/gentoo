# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

SANSV="2.010R-ro/1.065R-it"
SERIFV="1.017R"
CODEV="1.017R"

DESCRIPTION="Adobe's open source typeface family designed for UI environments"
HOMEPAGE="http://adobe-fonts.github.io/source-sans-pro
	http://adobe-fonts.github.io/source-serif-pro
	http://adobe-fonts.github.io/source-code-pro"
SRC_URI="https://github.com/adobe-fonts/source-sans-pro/archive/${SANSV}.tar.gz -> source-sans-pro-${PV}.tar.gz
	https://github.com/adobe-fonts/source-serif-pro/archive/${SERIFV}.tar.gz -> source-serif-pro-${PV}.tar.gz
	https://github.com/adobe-fonts/source-code-pro/archive/${CODEV}.tar.gz -> source-code-pro-${PV}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x64-macos"
IUSE="cjk"

RDEPEND="media-libs/fontconfig
	cjk? ( media-fonts/source-han-sans )"

S=${WORKDIR}
FONT_S="${S}"
FONT_SUFFIX="otf"
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )
RESTRICT="binchecks strip"

src_prepare() {
	mv source-*/OTF/*.otf . || die
}

src_install() {
	font_src_install
	for d in source-sans-pro-${SANSV/\//-} source-serif-pro-${SERIFV} source-code-pro-${CODEV}; do
		dohtml ${d}/*.html
	done
}
