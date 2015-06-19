# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vrrpd/vrrpd-1.0.ebuild,v 1.1 2013/12/03 22:49:22 robbat2 Exp $

EAPI=5

DESCRIPTION="Virtual Router Redundancy Protocol Daemon"
HOMEPAGE="http://www.sourceforge.net/projects/vrrpd"
SRC_URI="mirror://sourceforge/${PN}/${PN}/1.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="sys-devel/gcc"
RDEPEND=""

src_compile() {
	emake DBG_OPT="" MACHINEOPT="${CFLAGS}" PROF_OPT="${LDFLAGS}"
}

src_install() {
	dosbin vrrpd
	doman vrrpd.8
	dodoc FAQ Changes TODO scott_example doc/draft-ietf-vrrp-spec-v2-05.txt doc/rfc2338.txt.vrrp doc/draft-jou-duplicate-ip-address-02.txt
}
