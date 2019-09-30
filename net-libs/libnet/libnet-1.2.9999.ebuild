# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="library providing an API for commonly used low-level network functions"
HOMEPAGE="http://libnet-dev.sourceforge.net/ https://github.com/sam-github/libnet"
EGIT_REPO_URI="https://github.com/sam-github/libnet"

LICENSE="BSD BSD-2 HPND"
SLOT="1.1"
KEYWORDS=""
IUSE="doc static-libs"

DOCS=(
	README.md doc/{CHANGELOG,CONTRIB,DESIGN_NOTES,MIGRATION}
	doc/{PACKET_BUILDING,PORTED,RAWSOCKET_NON_SEQUITUR,TODO}
)
S=${WORKDIR}/${P/_/-}
PATCHES=(
	"${FILESDIR}"/${PN}-1.2-socklen_t.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if use doc ; then
		docinto html
		dodoc -r doc/html/*
		docinto sample
		dodoc sample/*.[ch]
	fi

	find "${D}" -name '*.la' -delete || die
}
