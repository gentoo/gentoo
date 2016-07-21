# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic

MY_P=${P/_beta/beta}
MY_PV=${PV/_beta/beta}
S=${WORKDIR}/${MY_P}

DESCRIPTION="tcptraceroute is a traceroute implementation using TCP packets"
HOMEPAGE="http://michael.toren.net/code/tcptraceroute/"
SRC_URI="http://michael.toren.net/code/tcptraceroute/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

DEPEND="
	net-libs/libnet
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

src_install() {
	dosbin tcptraceroute
	fowners root:wheel /usr/sbin/tcptraceroute
	fperms 4710 /usr/sbin/tcptraceroute
	doman tcptraceroute.1
	dodoc examples.txt README ChangeLog
	dohtml tcptraceroute.1.html
}
