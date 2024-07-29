# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Comprehensive OpenType font set of mathematical symbols and alphabets"
HOMEPAGE="https://www.stixfonts.org/"
BASE_URI="https://raw.githubusercontent.com/stipub/${PN/-/}/v${PV}"
SRC_URI="${BASE_URI}/zipfiles/static_otf.zip -> ${P}-otf.zip
	${BASE_URI}/docs/FONTLOG.txt -> ${P}-FONTLOG.txt
	${BASE_URI}/docs/STIXTwoMath-Regular.pdf -> ${P}-STIXTwoMath-Regular.pdf
	${BASE_URI}/docs/STIXTwoText-Regular.pdf -> ${P}-STIXTwoText-Regular.pdf
"
S="${WORKDIR}/static_otf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos"
IUSE=""

RESTRICT="binchecks strip test"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="otf"

src_install() {
	font_src_install

	local doc
	for doc in FONTLOG.txt STIXTwo{Math,Text}-Regular.pdf; do
		newdoc "${DISTDIR}"/${P}-${doc} ${doc}
	done
}
