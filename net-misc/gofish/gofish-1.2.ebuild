# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Gofish gopher server"
HOMEPAGE="http://gofish.sourceforge.net"
SRC_URI="mirror://sourceforge/gofish/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

pkg_setup() {
	enewgroup gopher
	enewuser gopher -1 -1 -1 gopher
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		--disable-mmap-cache
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc Configure_GoFish
	newinitd "${FILESDIR}"/gofish.rc gofish
	newconfd "${FILESDIR}"/gofish.confd gofish
}
