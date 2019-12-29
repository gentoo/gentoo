# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="library providing an API for commonly used low-level network functions"
HOMEPAGE="http://libnet-dev.sourceforge.net/ https://github.com/libnet/libnet"
EGIT_REPO_URI="https://github.com/libnet/libnet"

LICENSE="BSD BSD-2 HPND"
SLOT="1.1"
KEYWORDS=""
IUSE="static-libs"

DOCS=(
	ChangeLog.md README.md doc/{MIGRATION,RAWSOCKET,TODO}.md
)
S=${WORKDIR}/${P/_/-}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
