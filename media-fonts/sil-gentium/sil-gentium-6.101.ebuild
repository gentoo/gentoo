# Copyright 2004-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN="GentiumPlus"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Gentium Plus unicode font for Latin and Greek languages"
HOMEPAGE="https://software.sil.org/gentium/"
SRC_URI="https://software.sil.org/downloads/r/gentium/${MY_PN}-${PV}.zip -> ${P}.zip"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos"
IUSE="doc"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

src_unpack() {
	unpack ${A}
	rm -R "${S}"/documentation/source/
}

src_install() {
	font_src_install
	use doc && dodoc -r "${S}"/documentation
}
