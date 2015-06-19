# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/quicktables/quicktables-2.3.ebuild,v 1.2 2005/07/12 07:27:35 dholm Exp $

DESCRIPTION="a quick iptables script generator"
HOMEPAGE="http://qtables.radom.org/"
SRC_URI="http://qtables.radom.org/files/${P}.tar.gz"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

RDEPEND="net-firewall/iptables"

src_install() {
	dosbin quicktables-2.3 || die
	dodoc changes readme todo
}
