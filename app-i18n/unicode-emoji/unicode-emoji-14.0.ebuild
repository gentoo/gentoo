# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="UTS #51 Unicode Emoji"
HOMEPAGE="https://unicode.org/emoji/techindex.html"
DATA_URI="https://unicode.org/Public/${PN#*-}/${PV}"
UCD_URI="https://unicode.org/Public/${PV}.0/ucd/${PN#*-}"
SRC_URI="${DATA_URI}/${PN#*-}-sequences.txt -> ${PN}-sequences-${PV}.txt
	${DATA_URI}/${PN#*-}-test.txt -> ${PN}-test-${PV}.txt
	${DATA_URI}/${PN#*-}-zwj-sequences.txt -> ${PN}-zwj-sequences-${PV}.txt
	${UCD_URI}/${PN#*-}-data.txt -> ${PN}-data-${PV}.txt
	${UCD_URI}/${PN#*-}-variation-sequences.txt -> ${PN}-variation-sequences-${PV}.txt"

LICENSE="unicode"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND=""
S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	local a
	insinto /usr/share/${PN/-//}
	for a in ${A}; do
		newins "${DISTDIR}"/${a} $(echo ${a} | sed "s/${PN%-*}-\(.*\)-${PV}/\1/")
	done
}
