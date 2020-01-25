# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="IPTables firewall setup script"
LICENSE="GPL-2"
HOMEPAGE="https://www.lutel.pl/lutelwall/"
SRC_URI="https://www.lutel.pl/wp-content/uploads/${PV}/${P}.tar.gz"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc ~sparc x86"

RDEPEND="
	>=net-firewall/iptables-1.2.6
	>=sys-apps/gawk-3.1
	sys-apps/iproute2
"

src_install() {
	insinto /etc
	doins lutelwall.conf

	dosbin lutelwall
	doinitd "${FILESDIR}"/lutelwall

	dodoc FEATURES ChangeLog
}

pkg_postinst() {
	elog "Basic configuration file is /etc/lutelwall.conf"
	elog "Adjust it to your needs before using"
}
