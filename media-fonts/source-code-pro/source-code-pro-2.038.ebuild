# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font optfeature

REALV="2.038R-ro/1.058R-it/1.018R-VAR"

DESCRIPTION="Monospaced font family for user interface and coding environments"
HOMEPAGE="https://adobe-fonts.github.io/source-code-pro/"
SRC_URI="https://github.com/adobe-fonts/source-code-pro/archive/${REALV}.tar.gz -> source-code-pro-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${REALV//\//-}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~x64-macos"

RESTRICT="binchecks strip"

RDEPEND="
	media-libs/fontconfig
	!media-fonts/source-pro
"

FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )
FONT_SUFFIX="otf"

src_prepare() {
	default
	mv OTF/*.otf . || die
}

pkg_postinst() {
	optfeature_header "Other variants of this font are:"
	optfeature "Chinese, Japanese and Korean support" media-fonts/source-han-sans
	optfeature "the sans-serif variant" media-fonts/source-sans
	optfeature "the serif variant" media-fonts/source-serif
}
