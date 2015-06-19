# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/autossh/autossh-1.4d.ebuild,v 1.4 2014/12/05 10:18:05 ago Exp $

EAPI=5

DESCRIPTION="Automatically restart SSH sessions and tunnels"
HOMEPAGE="http://www.harding.motd.ca/autossh/"
SRC_URI="http://www.harding.motd.ca/${PN}/${P}.tgz"

LICENSE="BSD"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 ~sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
SLOT="0"

RDEPEND="net-misc/openssh"

src_prepare() {
	sed -i -e "s:\$(CC):& \$(LDFLAGS):" Makefile.in || die
}

src_install() {
	dobin autossh
	dodoc CHANGES README autossh.host rscreen
	doman autossh.1
}
