# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Small Footprint CIM Client Library"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/sblim"
SRC_URI="mirror://sourceforge/project/sblim/${PN}/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	net-misc/curl[ssl]
"
RDEPEND="${DEPEND}"

DOCS=()

src_configure() {
	local myconf=(
		--enable-http-chunking
		--disable-static
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
