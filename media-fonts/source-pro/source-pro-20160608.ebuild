# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

SANSV="2.020R-ro/1.075R-it"
SERIFV="1.017R"
CODEV="2.030R-ro/1.050R-it"

DESCRIPTION="Adobe's open source typeface family designed for UI environments"
HOMEPAGE="https://adobe-fonts.github.io/source-sans-pro/
	https://adobe-fonts.github.io/source-serif-pro/
	https://adobe-fonts.github.io/source-code-pro/"
SRC_URI="https://github.com/adobe-fonts/source-sans-pro/archive/${SANSV}.tar.gz -> source-sans-pro-${PV}.tar.gz
	https://github.com/adobe-fonts/source-serif-pro/archive/${SERIFV}.tar.gz -> source-serif-pro-${PV}.tar.gz
	https://github.com/adobe-fonts/source-code-pro/archive/${CODEV}.tar.gz -> source-code-pro-${PV}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x64-macos"
IUSE="cjk"

RDEPEND="media-libs/fontconfig
	cjk? ( media-fonts/source-han-sans )"

S=${WORKDIR}
FONT_S="${S}"
FONT_SUFFIX="otf"
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )
RESTRICT="binchecks strip"

src_prepare() {
	default
	mv source-*/OTF/*.otf . || die
}

src_install() {
	font_src_install
	for d in source-sans-pro-${SANSV/\//-} source-serif-pro-${SERIFV} source-code-pro-${CODEV/\//-}; do
		newdoc ${d}/README.md README-${d}.md
	done
}
