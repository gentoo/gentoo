# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""
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
