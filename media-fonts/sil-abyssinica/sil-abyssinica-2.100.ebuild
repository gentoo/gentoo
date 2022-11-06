# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="AbyssinicaSIL-${PV}"
inherit font

DESCRIPTION="SIL Opentype Unicode fonts for Ethiopic languages"
HOMEPAGE="https://software.sil.org/abyssinica/"
SRC_URI="https://software.sil.org/downloads/r/${PN/sil-/}/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~loong ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-macos"
IUSE="doc"

BDEPEND="app-arch/unzip"

DOCS=( FONTLOG.txt OFL-FAQ.txt README.txt )

FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	use doc && dodoc -r "${S}"/documentation
}
