# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fast Audio Playlist Generator"
HOMEPAGE="http://royale.zerezo.com/fapg/"
SRC_URI="http://royale.zerezo.com/fapg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="xspf"

DEPEND="xspf? ( >=dev-libs/uriparser-0.6.3 )"
RDEPEND="${DEPEND}"

src_configure() {
	local myconf=""
	use xspf || myconf="${myconf} --disable-xspf"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
