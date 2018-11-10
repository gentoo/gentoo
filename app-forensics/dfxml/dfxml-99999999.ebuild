# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

DESCRIPTION="Digital Forensics XML"
HOMEPAGE="https://github.com/simsong/dfxml"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-libs/expat
"
RDEPEND="
	${DEPEND}
"

S=${WORKDIR}/${P}/src

src_prepare() {
	default

	eautoreconf
}
