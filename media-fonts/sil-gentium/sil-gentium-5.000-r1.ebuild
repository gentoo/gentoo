# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_PN="GentiumPlus"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Gentium Plus unicode font for Latin and Greek languages"
HOMEPAGE="http://scripts.sil.org/gentium"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=${MY_P}.zip&filename=${MY_P}.zip -> ${P}.zip
	compact? ( http://scripts.sil.org/cms/scripts/render_download.php?format=file&media_id=GentiumPlusCompact-${PV}b.zip&filename=GentiumPlusCompact-${PV}.zip -> ${MY_PN}Compact-${PV}.zip )"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="compact doc"

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="GENTIUM-FAQ.txt OFL-FAQ.txt"
FONT_SUFFIX="ttf"

S="${WORKDIR}/${MY_PN}-${PV}"
FONT_S="${S}"

src_unpack() {
	unpack ${A}

	if use compact; then
		mv "${WORKDIR}"/${MY_PN}Compact-${PV}/*.${FONT_SUFFIX} "${FONT_S}" || die
	fi
}

src_install() {
	font_src_install
	use doc && dodoc -r "${S}"/documentation
}
