# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
