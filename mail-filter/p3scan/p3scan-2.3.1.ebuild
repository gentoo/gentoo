# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/p3scan/p3scan-2.3.1.ebuild,v 1.5 2014/08/10 21:16:46 slyfox Exp $

inherit eutils user

DESCRIPTION="This is a full-transparent proxy-server for POP3-Clients"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://p3scan.sf.net/"

DEPEND="net-mail/ripmime
	dev-libs/libpcre"
RDEPEND="net-firewall/iptables"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc x86"
IUSE=""

src_compile() {
	emake || die
}

src_install () {
	newinitd ${FILESDIR}/${PN}.init ${PN}

	dosbin ${PN} || die

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins ${PN}.conf ${PN}-*.mail
	doins ${PN}-*.mail

	keepdir /var/run/${PN}

	keepdir /var/spool/${PN}
	keepdir /var/spool/${PN}/children
	keepdir /var/spool/${PN}/notify

	fowners mail:mail /var/run/${PN}
	fperms 700 /var/run/${PN}

	fowners mail:mail /var/spool/${PN}
	fperms 700 /var/spool/${PN}

	fowners mail:mail /var/spool/${PN}/children
	fperms 700 /var/spool/${PN}/children

	fowners mail:mail /var/spool/${PN}/notify
	fperms 700 /var/spool/${PN}/notify

	doman p3scan.8.gz p3scan_readme.8.gz

	dodoc AUTHORS CHANGELOG CONTRIBUTERS LICENSE NEWS README \
		README-rpm spamfaq.* TODO.list
}

pkg_postinst() {
	enewuser mail 8 /bin/true /var/spool/mail mail

	if [ ! -L /etc/${PN}/${PN}.mail ]; then
		ln -sf /etc/${PN}/${PN}-en.mail /etc/${PN}/${PN}.mail
	fi

	echo
	elog "Default infected notification template language is set to english, change the"
	elog "symbolic link /etc/${PN}/${PN}.mail if you want it in another language."
	elog
	elog "To start ${PN}, you can use /etc/init.d/${PN} start"
	elog
	elog "You need port-redirecting, a rule like:"
	elog "  iptables -t nat -A PREROUTING -p tcp -i eth0 --dport pop3 -j REDIRECT --to 8110"
	elog "to forward pop3 connections incoming from eth0 interface."
	elog
	elog "You will also need to configure at least following in /etc/${PN}/${PN}.conf:"
	elog "scannertype, scanner, virusregexp"
	echo
}
