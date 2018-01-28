# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="UTR #51 Unicode Emoji"
HOMEPAGE="http://unicode.org/emoji"
BASE_URI="http://${PN%-*}.org/Public/${PN/*-}/${PV}"
SRC_URI="${BASE_URI}/${PN/*-}-data.txt -> ${PN}-data-${PV}.txt
	${BASE_URI}/${PN/*-}-sequences.txt -> ${PN}-sequences-${PV}.txt
	${BASE_URI}/${PN/*-}-test.txt -> ${PN}-test-${PV}.txt
	${BASE_URI}/${PN/*-}-variation-sequences.txt -> ${PN}-variation-sequences-${PV}.txt
	${BASE_URI}/${PN/*-}-zwj-sequences.txt -> ${PN}-zwj-sequences-${PV}.txt"

LICENSE="unicode"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ia64 ppc ppc64 ~sparc x86"
IUSE=""

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
