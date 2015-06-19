# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam-script/pam-script-1.1.6.ebuild,v 1.3 2013/05/09 05:44:36 radhermit Exp $

EAPI=5

inherit multilib

DESCRIPTION="PAM module for executing scripts during authorization, password changes, and sessions"
HOMEPAGE="http://sourceforge.net/projects/pam-script/ https://github.com/jeroennijhof/pam_script/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="virtual/pam"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--libdir=/$(get_libdir)/security \
		--sysconfdir=/etc/security/${PN}
}

src_install() {
	default

	if use examples ; then
		docinto examples
		dodoc etc/README.examples
		exeinto /usr/share/doc/${PF}/examples
		doexe etc/{logscript,tally}
		docompress -x /usr/share/doc/${PF}/examples/{logscript,tally}
	fi
}
