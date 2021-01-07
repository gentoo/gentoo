# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A challenge/response-based white-list spam filter"
HOMEPAGE="http://mapson.sourceforge.net/"
SRC_URI="mirror://sourceforge/mapson/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND="
	acct-user/mail
	virtual/mta
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-respect-AR.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with debug)
}

src_install() {
	emake DESTDIR="${ED}" install

	dodoc AUTHORS INSTALL NEWS README
	doman doc/mapson.1

	docinto html
	dodoc doc/mapson.html

	insinto /etc/mapson
	newins sample-config mapson.config

	insinto /usr/share/mapson
	newins sample-challenge-template challenge-template

	rm -f "${ED}"/etc/sample-config || die
	rm -f "${ED}"/usr/share/{mapson.html,sample-challenge-template} || die
}
