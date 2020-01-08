# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="AbyssinicaSIL-${PV}"
inherit font

DESCRIPTION="SIL Opentype Unicode fonts for Ethiopic languages"
HOMEPAGE="https://software.sil.org/abyssinica"
SRC_URI="https://software.sil.org/downloads/r/${PN/sil-/}/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-macos ~x86-macos"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="FONTLOG.txt OFL-FAQ.txt README.txt"
FONT_SUFFIX="ttf"
FONT_S="${WORKDIR}/${MY_P}"
S="${FONT_S}"

src_install() {
	font_src_install
	use doc && dodoc -r "${S}"/documentation
}
