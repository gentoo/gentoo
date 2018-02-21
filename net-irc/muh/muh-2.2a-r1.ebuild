# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Persistent IRC bouncer"
HOMEPAGE="http://mind.riot.org/muh/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc x86"
IUSE="ipv6"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	econf --datadir=/usr/share/muh $(use_enable ipv6)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog TODO
}

pkg_postinst() {
	elog
	elog "You'll need to configure muh before running it."
	elog "Put your config in ~/.muh/muhrc"
	elog "A sample config is /usr/share/muh/muhrc"
	elog "For more information, see the documentation."
	elog
}
