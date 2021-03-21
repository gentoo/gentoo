# Copyright 2004-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="GentiumPlus"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Gentium Plus unicode font for Latin and Greek languages"
HOMEPAGE="https://software.sil.org/gentium/"
SRC_URI="https://software.sil.org/downloads/r/gentium/${MY_P}.zip -> ${P}.zip
	compact? ( https://software.sil.org/downloads/r/gentium/${MY_PN}Compact-${PV}.zip )"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 s390 sparc x86 ~ppc-macos ~x64-macos"
IUSE="compact doc"

BDEPEND="app-arch/unzip"

DOCS=( GENTIUM-FAQ.txt OFL-FAQ.txt )

FONT_SUFFIX="ttf"

src_unpack() {
	unpack ${A}

	if use compact; then
		mv "${WORKDIR}"/${MY_PN}Compact-${PV}/*.${FONT_SUFFIX} "${S}" || die
	fi
}

src_install() {
	font_src_install
	use doc && dodoc -r "${S}"/documentation
}
