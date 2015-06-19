# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pop-before-smtp/pop-before-smtp-1.42.ebuild,v 1.4 2011/11/28 11:54:54 phajdan.jr Exp $

EAPI=4

DESCRIPTION="a simple daemon to allow email relay control based on successful POP or IMAP logins"
HOMEPAGE="http://popbsmtp.sourceforge.net"
SRC_URI="mirror://sourceforge/popbsmtp/${P}.tar.gz"

LICENSE="|| ( GPL-2 BSD Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl[berkdb]
	dev-perl/Net-Netmask
	dev-perl/TimeDate"

src_prepare() {
	# enable syslog
	sed -i \
		-e "/^=cut #============================= syslog ===========================START=$/d" \
		-e "/^=cut #============================= syslog =============================END=$/d" \
		"${S}"/pop-before-smtp-conf.pl \
			|| die "sed pop-before-smtp-conf.pl failed"
}

src_install() {
	dosbin pop-before-smtp || die "dosbin failed"
	dodoc README ChangeLog TODO contrib/README.QUICKSTART
	insinto /etc
	doins pop-before-smtp-conf.pl || die "doins failed"
	newinitd "${FILESDIR}/pop-before-smtp.init" pop-before.smtp \
		|| die "newinitd failed"
}
