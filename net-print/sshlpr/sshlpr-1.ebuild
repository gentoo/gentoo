# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/sshlpr/sshlpr-1.ebuild,v 1.2 2011/10/12 01:23:21 radhermit Exp $

EAPI="4"

DESCRIPTION="ssh-lpr backend for cups -- print to remote systems over ssh"
HOMEPAGE="http://www.masella.name/technical/sshlpr.html"
SRC_URI="http://dev.gentoo.org/~radhermit/distfiles/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}
	net-misc/openssh
	sys-apps/shadow"

S="${WORKDIR}"

src_install() {
	exeinto $(cups-config --serverbin)/backend
	exeopts -m0700
	doexe ${PN}
}
