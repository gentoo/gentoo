# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/p3scan/p3scan-2.3.2-r1.ebuild,v 1.4 2014/08/10 21:16:46 slyfox Exp $

EAPI="2"

inherit eutils toolchain-funcs user

DESCRIPTION="This is a full-transparent proxy-server for POP3-Clients"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://p3scan.sf.net/"

# Older ripmime did not install a library
DEPEND="dev-libs/libpcre
	>=net-mail/ripmime-1.4.0.9
	"
RDEPEND="net-firewall/iptables"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/p3scan-ocreat.patch"

	# respect CC (bug #244144), and CFLAGS (bug #240786)
	sed -i \
		-e "s/gcc/$(tc-getCC)/" \
		-e "s:^CFLAGS=-Wall -O2 :CFLAGS=${CFLAGS} :" \
		-e '/^LDFLAGS=/d' \
		-e '/^ripmime\/libripmime/,+7d' \
		-e '/^\.c\.o:/,+3d' \
		-e '$ap3scan: LDLIBS:=-lripmime -lpcre -lssl -lcrypto\np3scan: $(OBJECTS)' \
		Makefile || die
	# Be sure the system copy is used
	rm -rf ripmime/
}

src_compile() {
	emake || die
}

src_install () {
	newinitd "${FILESDIR}"/${PN}.init ${PN}

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

	dodoc AUTHORS CHANGELOG CONTRIBUTERS NEWS README \
		README-rpm TODO.list p3scan.sh spamfaq.*
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
	elog "You will need to configure at least following in /etc/${PN}/${PN}.conf:"
	elog "scannertype, scanner, virusregexp"
	elog
	elog "An example scanner script has been installed to:"
	elog "/usr/share/doc/${PF}/"
	echo
}
