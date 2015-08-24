# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="PAM module for executing scripts during authorization, password changes, and sessions"
HOMEPAGE="http://sourceforge.net/projects/pam-script/ https://github.com/jeroennijhof/pam_script/"
SRC_URI="https://dev.gentoo.org/~radhermit/dist/${P}.tar.gz"

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
