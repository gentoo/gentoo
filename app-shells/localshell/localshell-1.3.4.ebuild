# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/localshell/localshell-1.3.4.ebuild,v 1.5 2014/08/10 18:21:29 slyfox Exp $

EAPI=4

inherit base eutils

DESCRIPTION="Localshell allows per-user/group local control of shell execution"
HOMEPAGE="http://git.orbis-terrarum.net/?p=infrastructure/localshellc.git;a=summary"
SRC_URI="${HOMEPAGE}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_configure() {
	# this is a shell, it needs to be in /bin
	econf --bindir=/bin --sysconfdir=/etc
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,INSTALL}
}

pkg_postinst() {
	elog "Remember to add /bin/localshell to /etc/shells and create"
	elog "/etc/localshell.conf based on the included configuration examples"
}
