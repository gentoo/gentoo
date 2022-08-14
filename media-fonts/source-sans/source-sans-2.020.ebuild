# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_PN=${PN}-pro

inherit font optfeature

REALV="2.020R-ro/1.075R-it"

DESCRIPTION="Sans serif font family for user interface environments"
HOMEPAGE="https://adobe-fonts.github.io/source-sans/"
SRC_URI="https://github.com/adobe-fonts/source-sans/archive/${REALV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${REALV//\//-}"

LICENSE="OFL-1.1"
SLOT="pro"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

RESTRICT="binchecks strip"

RDEPEND="
	media-libs/fontconfig
	!media-fonts/source-pro
"

FONT_CONF=( "${FILESDIR}"/63-${FONT_PN}.conf )
FONT_SUFFIX="otf"

src_prepare() {
	default
	mv OTF/*.otf . || die
}

pkg_postinst() {
	optfeature_header "Other variants of this font are:"
	optfeature "the monospace variant" media-fonts/source-code-pro
	optfeature "Chinese, Japanese and Korean support" media-fonts/source-han-sans
	optfeature "the serif variant" media-fonts/source-serif
}
